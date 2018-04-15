module ImageHelper
  BUCKET_NAME = 'bg.image.converter'.freeze

  def self.save_file_to_path(file, path)
    File.open(path, 'wb+') do |f|
      f.write file.read
    end
  end

  def self.upload_file_to_s3(file_path, desired_name, bucket_name)
    # s3 = Aws::S3::Resource.new
    # bucket = s3.bucket(bucket_name)
    # image_object = bucket.put_object({body: file, key: file_id})

    # Of course it would probably be best to use the AWS gem here, but for
    # some reason it takes about 30 seconds to upload an image
    `~/.local/bin/aws s3 cp #{file_path} s3://#{bucket_name}/#{desired_name}`
  end

  def self.convert_file(file, original_name, desired_name)
    ImageHelper.save_file_to_path file, original_name

    # TODO: Run the conversion in a Docker container
    # TODO: The status code of the operation should be handled. For example if there was an error.
    `convert #{original_name} #{desired_name}`

    File.delete original_name
  end

  def self.upload_converted_file(file, original_name, desired_name, file_id)
    ImageHelper.convert_file file, original_name, desired_name
    ImageHelper.upload_file_to_s3 desired_name, file_id, BUCKET_NAME
    File.delete desired_name
  end
end
