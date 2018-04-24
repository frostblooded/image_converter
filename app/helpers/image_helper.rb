module ImageHelper
  BUCKET_NAME = 'bg-image-converter'.freeze
  DOCKER_CONVERSION_IMAGE = 'ncsapolyglot/converters-imagemagick'.freeze

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
    # some reason it takes about 30 seconds to upload an image when I am using it,
    # but it works fine like this
    `~/.local/bin/aws s3 cp #{file_path} s3://#{bucket_name}/#{desired_name}`
  end

  def self.convert_file(file, original_name, desired_name)
    # Don't actually convert if input and output are the same
    return if original_name == desired_name

    # TODO: Use docker compose to run the conversion container with the server
    # TODO: Handle conversion status code
    # TODO: Containerize the server and make it start the conversion container
    # Presumes that the Docker container is already running in the background
    # Find docker based on its image (AKA ancestor)
    container_filters = { ancestor: [DOCKER_CONVERSION_IMAGE] }.to_json
    container = Docker::Container.all(filters: container_filters).first
    container.store_file(original_name, file.read)
    container.exec(['convert', original_name, desired_name])
    save_file_to_path(container.read_file(original_name), desired_name)
    container.exec(['rm', original_name])
    container.exec(['rm', desired_name])
  end

  def self.test_lambda_call
    client = Aws::Lambda::Client.new region: 'eu-west-3'
    resp = client.invoke(function_name: 'python_test', invocation_type: 'RequestResponse')
    puts "Lambda response: #{resp.payload.string}"
  end

  def self.upload_converted_file(file, original_name, desired_name, file_id)
    ImageHelper.convert_file file, original_name, desired_name
    ImageHelper.upload_file_to_s3 desired_name, file_id, BUCKET_NAME
    File.delete desired_name
    test_lambda_call
  end
end
