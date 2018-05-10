require 'rails_helper'

feature 'User converts image', type: :feature do
  before do
    allow(ImageHelper).to receive :upload_file_to_s3
    allow(ImageHelper).to receive :test_lambda_call
    allow(ImageHelper).to receive :test_ses
  end

  scenario 'to other format' do
    visit root_path

    attach_file 'original_image', TEST_IMAGE_PATH
    select 'jpeg', from: 'desired_format'
    click_button 'submit'

    expect(page).to have_css('img')
  end

  scenario 'to same format' do
    visit root_path

    attach_file 'original_image', TEST_IMAGE_PATH
    select 'png', from: 'desired_format'
    click_button 'submit'

    expect(page).to have_text 'Please choose a different format from the image\'s format'
  end
end
