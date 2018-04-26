require 'rails_helper'
require 'open-uri'

describe(ImageHelper) do
  before :each do
    FakeFS.activate!
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
    IMAGE_PATH = File.expand_path(File.join(__dir__, '..', 'image')).freeze

    before do
      @original_name = IMAGE_PATH + '.png'
      FakeFS::FileSystem.clone(@original_name)

      # Setup tempfile
      # Tempfile uses /tmp, but it isn't in FakeFS
      Dir.mkdir '/tmp' unless Dir.exist? '/tmp'

      @tempfile = Tempfile.open

      File.open @original_name, 'r' do |f|
        @tempfile.write(f.read)
      end
    end

    it 'doesn\'t do anything if original and desired name are equal' do
      @desired_name = @original_name
      expect(ImageHelper).not_to receive(:convert_in_container)
      ImageHelper.convert_file @tempfile, @original_name, @desired_name
      expect(Dir.glob(@desired_name).length).to eq 1
    end

    it 'converts and deletes files correctly' do
      @desired_name = IMAGE_PATH + '.jpg'
      ImageHelper.convert_file @tempfile, @original_name, @desired_name
      expect(Dir.glob(@desired_name).length).to eq 1
    end

    after do
      @tempfile.close
      @tempfile.unlink
    end
  end

  after :each do
    FakeFS.deactivate!
  end
end

