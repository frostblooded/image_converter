module ImageHelper
  BUCKET_NAME = 'bg.image.converter'.freeze

  def self.save_file_to_path(file_contents, path)
    File.open(path, 'wb+') do |f|
      f.write file_contents
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
    # ImageHelper.save_file_to_path file, original_name

    # Don't actually convert if input and output are the same
    return if original_name == desired_name

    # TODO: Run the conversion in a Docker container
    # TODO: Handle conversion status code
    image = Docker::Image.create(fromImage: 'ncsapolyglot/converters-imagemagick')
    container = image.run
    container.store_file('/' + original_name, file.read)
    container.exec(['convert', original_name, desired_name])
    container.exec(['ls'])
    save_file_to_path(container.read_file('/' + original_name), desired_name)
    container.stop

    # File.delete original_name
  end

  def self.upload_converted_file(file, original_name, desired_name, file_id)
    ImageHelper.convert_file file, original_name, desired_name
    ImageHelper.upload_file_to_s3 desired_name, file_id, BUCKET_NAME
    File.delete desired_name
  end
end
