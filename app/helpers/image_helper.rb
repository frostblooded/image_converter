module ImageHelper
  def self.save_file_to_path(file, path)
    File.open(path, 'wb+') do |f|
      f.write file.read
    end
  end
end
