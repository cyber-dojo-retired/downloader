require_relative 'downloader_test_base'

class ExternalDiskTest < DownloaderTestBase

  def self.id58_prefix
    'FDF'
  end

  test 'D4C',
  'what gets written gets read back' do
    Dir.mktmpdir('file_writer') do |tmp_dir|
      pathed_filename = tmp_dir + '/limerick.txt'
      content = 'the boy stood on the burning deck'
      disk.write_txt(pathed_filename, content)
      File.open(pathed_filename, 'r') { |fd| assert_equal content, fd.read }
    end
  end

end
