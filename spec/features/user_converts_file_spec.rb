require 'rails_helper'

feature 'User converts image' do
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
