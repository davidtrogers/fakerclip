module Fakerclip

  class Reads

    SUBDOMAIN_BUCKET_REGEX = %r{https?:\/\/(.+)\.s3\.amazonaws\.com}
    PATH_BUCKET_REGEX      = %r{https?:\/\/s3\.amazonaws\.com\/([^\/]+)\/}

    def self.activate
      Paperclip::Attachment.default_options[:url_generator] = UrlGenerator
    end

    class UrlGenerator < ::Paperclip::UrlGenerator

      def for(style_name, options)
        uri = URI.parse(super)

        case uri.to_s
        when SUBDOMAIN_BUCKET_REGEX
          "/fake_s3_#{Rails.env}/#{$1}#{uri.request_uri}"
        when PATH_BUCKET_REGEX
          "/fake_s3_#{Rails.env}#{uri.request_uri}"
        else
          uri.to_s
        end
      end
    end
  end
end
