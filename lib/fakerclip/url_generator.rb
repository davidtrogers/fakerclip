module Fakerclip

  class UrlGenerator < ::Paperclip::UrlGenerator

    def for(style_name, options)
      uri = URI.parse(super)

      if uri.to_s.match(/\.s3\.amazonaws\.com/)
        bucket = uri.host.split(/\./, 2).first
        "/fake_s3_#{Rails.env}/#{bucket}#{uri.request_uri}"
      else
        uri.to_s
      end
    end
  end

  Paperclip::Attachment.default_options[:url_generator] = Fakerclip::UrlGenerator
end