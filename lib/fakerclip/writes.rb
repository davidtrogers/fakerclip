module Fakerclip

  # TODO: * set mocking for Excon to only apply to *some-bucket*.s3.amazonaws.com and only
  # while paperclip is making the requests, so we don't clobber other legit requests.
  class Writes

    def self.activate
      # fog gem support
      ::Excon.stub({ method: "PUT" }, FakeS3::ExconResponder.block)
      ::Excon.defaults[:mock] = true

      # aws-sdk gem support
      Artifice.activate_with(FakeS3::AWSSDKResponder.new)
    end

    class S3Request

      attr_accessor :body, :etag, :s3_path, :s3_bucket

      def initialize(env)
        self.body      = env['rack.input'] && env['rack.input'].read || env[:body]
        self.s3_bucket = (env['HTTP_HOST'] || env[:host]).split('.').first
        self.s3_path   = env['PATH_INFO'] || CGI.unescape(env[:path])
        self.etag      = Digest::MD5::hexdigest(body)
      end
    end

    class FakeS3

      class AWSSDKResponder

        def call(env)
          Response.new(env).to_hash.values
        end
      end

      class ExconResponder

        def self.block
          Proc.new { |env| Response.new(env).to_hash }
        end
      end

      class Response

        def initialize(env)
          @request = S3Request.new(env)

          LocalS3Object.new(@request.s3_bucket, @request.s3_path).save(@request.body)
        end

        def to_hash
          # TODO: generate etags for multipart uploads
          {
            status: 200,
            headers: { "ETag" => @request.etag },
            body: ["OK"]
          }
        end
      end

      class LocalS3Object

        def initialize(s3_bucket, s3_file_path)
          @local_file_path = File.join(path_to_local_s3, s3_bucket, s3_file_path)

          ensure_path_exists
        end

        # writes the file to the fake s3
        def save(data)
          File.open(@local_file_path, "wb") {|file| file.write(data) }
        end

        private

        def path_to_local_s3
          Rails.root.join(File.join('public', "fake_s3_#{Rails.env}"))
        end

        def ensure_path_exists
          FileUtils.mkdir_p File.dirname(@local_file_path)
        end
      end
    end
  end
end
