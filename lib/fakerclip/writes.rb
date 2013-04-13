module Fakerclip

  class Writes

    def self.activate
      # stubbing writes to S3
      ::Excon.stub({ method: "PUT" }) do |params|

        # TODO: generate etags for multipart uploads
        etag            = Digest::MD5.hexdigest(params[:body])

        s3_bucket       = params[:host].split('.').first
        s3_file_path    = CGI.unescape params[:path]
        local_s3_path   = Rails.root.join(File.join('public', "fake_s3_#{Rails.env}"))
        local_file_path = File.join(local_s3_path, s3_bucket, s3_file_path)

        # creates the file tree, e.g. public/fake_s3_development/s3-bucket/files/1/
        FileUtils.mkdir_p File.dirname(local_file_path)

        # writes the file to the fake s3
        File.open(local_file_path, "wb") {|file| file.write(params[:body]) }

        # TODO: generate alternate statuses, e.g. if the file is not found
        {
          status: 200,
          headers: params[:headers].merge("ETag" => etag),
          body: params[:body]
        }
      end

      # TODO: set mocking for Excon to apply only to some-bucket.s3.amazonaws.com and only
      # while paperclip is making the requests, so we don't clobber other legit requests.
      ::Excon.defaults[:mock] = true
    end
  end
end
