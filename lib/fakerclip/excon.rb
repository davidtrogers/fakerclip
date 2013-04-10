module Excon

  class << self

    def new(url, params = {})

      # stubbing writes to S3
      Excon.stub({ method: "PUT" }) do |params|

        # TODO: limit stubbed requests to rails models using paperclip
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

        {
          status: 200,
          headers: params[:headers].merge("ETag" => etag),
          body: params[:body]
        }
      end

      # TODO: scope this to a request
      ::Excon::Connection.new(url, params.merge(mock: true))
    end
  end
end
