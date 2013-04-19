require 'spec_helper'

describe Fakerclip do

  let(:random_string)   { SecureRandom.random_bytes(32) }
  let(:file)            { File.open('tmp/random-bytes.bin', "wb") }
  let(:content_type)    { 'application/octet-stream' }
  let(:uploaded_file)   { Rack::Test::UploadedFile.new(file.path, content_type, true) }
  let(:local_file_path) { Rails.root.join("public/fake_s3_test/some-bucket/files/1/random-bytes.bin") }

  before do
    FileUtils.mkdir_p 'tmp'

    file.binmode.write(random_string)
    file.rewind
  end

  describe "Fog gem" do

    it "stores S3 objects to the file system" do
      expect(File.exists?(local_file_path)).to be_false

      FogS3GemUpload.create(file: uploaded_file)

      expect(File.exists?(local_file_path)).to be_true
      expect(File.open(local_file_path, "rb", &:read)).to eq random_string
    end

    it "gives paths to S3 objects on the file system" do
      upload = FogS3GemUpload.create(file: uploaded_file)

      upload.file.url.should match /\/fake_s3_test\/some-bucket\/files\/1\/random-bytes.bin\?\d+/
    end

    after do
      file.close

      FileUtils.rm_rf('tmp/')
      FileUtils.rm_rf(Rails.root.join('public/fake_s3_test'))
    end
  end

  describe "AWS SDK gem" do

    it "stores S3 objects to the file system" do
      expect(File.exists?(local_file_path)).to be_false

      AwsSdkS3GemUpload.create(file: uploaded_file)

      expect(File.exists?(local_file_path)).to be_true
      expect(File.open(local_file_path, "rb", &:read)).to eq random_string
    end

    it "gives paths to S3 objects on the file system" do
      upload = AwsSdkS3GemUpload.create(file: uploaded_file)

      upload.file.url.should match /\/fake_s3_test\/some-bucket\/files\/1\/random-bytes.bin\?\d+/
    end

    after do
      file.close

      FileUtils.rm_rf('tmp/')
      FileUtils.rm_rf(Rails.root.join('public/fake_s3_test'))
    end

  end
end
