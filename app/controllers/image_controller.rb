class ImageController < ApplicationController
  def convert
    image_param = params[:original_image]
    image_file = image_param.tempfile

    # TODO: Check if original format equals desired format
    original_format = image_param.content_type.split('/').last
    desired_format = params[:desired_format]

    # Use the object id to name the file. This is obviously a poor solution
    # since the object_id is not unique and an image can be overwritten at some point
    # if we choose to store the images with names based on their object_id,
    # but it works fine for this application.
    file_id = image_file.object_id.to_s
    original_name = file_id + '.' + original_format
    desired_name = file_id + '.' + desired_format

    # TODO: Save the files in the tmp directory while working with them
    ImageHelper.save_file_to_path image_file, original_name

    # Run the conversion in a Docker container
    `convert #{original_name} #{desired_name}`

    # TODO: Delete files from the filesystem after being done with them
    # TODO: Redirect to a new page that shows the new image and lets you download it or convert another image
    redirect_to image_url(object_id)
  end

  def show
    puts params[:file_name]
  end
end
