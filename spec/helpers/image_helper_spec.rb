require 'rails_helper'
require 'open-uri'

describe ImageHelper do
  IMAGE_BASE_PATH = File.expand_path(File.join(__dir__, '..', 'image')).freeze

  before :all do
    FakeFS.activate!
  end

  before do
    @original_name = IMAGE_BASE_PATH + '.png'
    FakeFS::FileSystem.clone(@original_name)

    # Tempfile uses /tmp, but it isn't in FakeFS
    Dir.mkdir '/tmp' unless Dir.exist? '/tmp'

    @tempfile = Tempfile.open

    File.open @original_name, 'r' do |f|
      @tempfile.write(f.read)
    end
  end

  describe '#save_file_to_path' do
    it 'creates file with correct contents' do
      file_name = '3.txt'
      text = SecureRandom.hex

      ImageHelper.save_file_to_path text, file_name
      expect(Dir.glob(file_name).length).to eq 1
      expect(File.read(file_name)).to eq text
    end
  end

  describe '#convert_file' do
    it 'converts and deletes files correctly' do
      @desired_name = IMAGE_BASE_PATH + '.jpg'
      ImageHelper.convert_file @tempfile, @original_name, @desired_name
      expect(Dir.glob(@desired_name).length).to eq 1
    end
  end

  describe '#upload_converted_file' do
    it 'removes file after upload' do
      allow(ImageHelper).to receive :upload_file_to_s3
      allow(ImageHelper).to receive :test_lambda_call
      allow(ImageHelper).to receive :test_ses

      @desired_name = IMAGE_BASE_PATH + '.jpg'

      ImageHelper.upload_converted_file @tempfile, @original_name,
                                        @desired_name, SecureRandom.hex

      expect(Dir.glob(@desired_name).length).to eq 0
    end
  end

  after do
    @tempfile.close
    @tempfile.unlink
  end

  after :all do
    FakeFS.deactivate!
  end
end

