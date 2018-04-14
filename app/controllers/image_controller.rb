class ImageController < ApplicationController
  def convert
    image_param = params[:original_image]
    image_file = image_param.tempfile

    original_format = image_param.content_type.split('/').last
    desired_format = params[:format]

    file_id = image_file.object_id.to_s # Use the object id to name the file
    original_name = file_id + '.' + original_format
    desired_name = file_id + '.' + desired_format

    File.open(original_name, 'wb+') do |f|
      f.write image_file.read
    end

    `convert #{original_name} #{desired_name}`

    redirect_to root_url
  end
end
