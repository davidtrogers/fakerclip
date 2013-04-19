class AwsSdkS3GemUpload < Upload

  has_attached_file :file,
                    :storage => :s3,
                    :s3_credentials => {
                      :access_key_id => "AWSACCESSKEY",
                      :secret_access_key => "AWSSECRETKEY"
                    },
                    :bucket => "some-bucket",
                    :s3_permissions => :public_read,
                    :path => ":attachment/:id/:basename.:extension"

  before_post_process :image?
end
