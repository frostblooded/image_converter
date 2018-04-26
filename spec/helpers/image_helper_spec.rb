require 'rails_helper'

describe '#save_file_to_path' do
  it 'creates file' do
    file_name = '3.txt'
    file = Tempfile.new file_name

    FakeFS do
      ImageHelper.save_file_to_path file, file_name
      file_exists = Dir.glob(file_name).length >= 1
      expect(file_exists).to be_truthy
    end
  end
end
