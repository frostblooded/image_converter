class ImageController < ApplicationController
  IMAGE_TMP_SAVE_PATH = '/tmp/'.freeze
  BUCKET_PUBLIC_URL = "https://s3.eu-west-3.amazonaws.com/#{ImageHelper::BUCKET_NAME}/".freeze

  def convert
    original_format = get_original_format params
    desired_format = params[:desired_format]

    # TODO: Make sure invalid formats aren't being passed in.
    if original_format == desired_format
      flash[:danger] = 'Please choose a different format from the image\'s format'
      return redirect_to root_path
    end

    file_id = convert_params_file params, original_format, desired_format
    redirect_to image_url(file_id)
  end

  def show
    image_id = params[:image_id]
    @image_url = BUCKET_PUBLIC_URL + image_id
  end

  private

  def convert_params_file(params, original_format, desired_format)
    image_file = params[:original_image].tempfile

    # Use the object id to name the file. This is obviously a poor solution
    # since the object_id is not unique and an image can be overwritten
    # at some point if we choose to store the images with names based
    # on their object_id, but it works fine for this application.
    file_id = get_file_id image_file
    original_name = get_original_name file_id, original_format
    desired_name = get_desired_name file_id, desired_format

    ImageHelper.upload_converted_file image_file, original_name,
                                      desired_name, file_id

    file_id
  end

  def get_original_format(params)
    params[:original_image].content_type.split('/').last
  end

  def get_original_name(file_id, original_format)
    get_file_name file_id, original_format
  end

  def get_desired_name(file_id, desired_format)
    get_file_name file_id, desired_format
  end

  def get_file_name(base_file_name, format)
    IMAGE_TMP_SAVE_PATH + base_file_name + '.' + format
  end

  def get_file_id(file)
    file.object_id.to_s
  end
end
