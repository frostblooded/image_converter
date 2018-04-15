class ImageController < ApplicationController
  IMAGE_TMP_SAVE_PATH = 'tmp/'
  BUCKET_PUBLIC_URL = 'https://s3.eu-west-3.amazonaws.com/bg.image.converter/'
  BUCKET_NAME = 'bg.image.converter'

  def convert
    # TODO: I should add checking for the parameters. Make sure invalid formats aren't being passed in.
    image_file = params[:original_image].tempfile

    # TODO: Check if original format equals desired format
    original_format = get_original_format params
    desired_format = params[:desired_format]

    # Use the object id to name the file. This is obviously a poor solution
    # since the object_id is not unique and an image can be overwritten at some point
    # if we choose to store the images with names based on their object_id,
    # but it works fine for this application.
    file_id = get_file_id image_file
    original_name = get_original_name file_id, original_format
    desired_name = get_desired_name file_id, desired_format

    # TODO: Save the files in the tmp directory while working with them
    ImageHelper.save_file_to_path image_file, original_name

    # TODO: Run the conversion in a Docker container
    # TODO: The status code of the operation should be handled. For example if there was an error.
    `convert #{original_name} #{desired_name}`

    ImageHelper.upload_file_to_s3 image_file, file_id, BUCKET_NAME
    File.delete original_name
    File.delete desired_name

    # TODO: Redirect to a new page that shows the new image and lets you download it or convert another image
    redirect_to image_url(image_object.key)
  end

  def show
    image_id = params[:image_id]
    @image_url = BUCKET_PUBLIC_URL + image_id
  end

private
  def get_original_format(params)
    params[:original_image].content_type.split('/').last
  end

  def get_original_name file_id, original_format
    get_file_name file_id, original_format
  end

  def get_desired_name  file_id, desired_format
    get_file_name file_id, desired_format
  end

  def get_file_name base_file_name, format
    IMAGE_TMP_SAVE_PATH + base_file_name + '.' + format
  end

  def get_file_id file
    file.object_id.to_s
  end
end
