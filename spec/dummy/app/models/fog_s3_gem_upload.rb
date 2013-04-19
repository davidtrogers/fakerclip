class FogS3GemUpload < Upload

  has_attached_file :file,
                    :storage => :fog,
                    :fog_public => true,
                    :fog_credentials => {
                      :provider => 'AWS',
                      :aws_access_key_id => "AWSACCESSKEY",
                      :aws_secret_access_key => "AWSSECRETKEY"
                    },
                    :fog_directory => "some-bucket",
                    :path => ":attachment/:id/:basename.:extension"

  before_post_process :image?
end
