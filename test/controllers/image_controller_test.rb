require 'test_helper'

class ImageControllerTest < ActionDispatch::IntegrationTest
  test "should get convert" do
    get image_convert_url
    assert_response :success
  end

end
