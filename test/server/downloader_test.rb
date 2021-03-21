require_relative 'downloader_test_base'

class DownloaderTest < DownloaderTestBase

  def self.id58_prefix
    'Q96'
  end

  test '23J', %w( downloader ) do
    tgz_filename, _tgz_bytes = downloader.download(id:'5U2J18')
    print tgz_filename
  end

end
