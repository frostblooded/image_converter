module ImageHelper
  def self.save_file_to_path(file, path)
    File.open(path, 'wb+') do |f|
      f.write file.read
    end
  end

  def self.upload_file_to_s3(file, key, bucket_name)
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(bucket_name)
    image_object = bucket.put_object({body: file, key: file_id})
  end
end
