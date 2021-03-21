require_relative 'downloader_test_base'

class ExternalsTest < DownloaderTestBase

  def self.id58_prefix
    '7A9'
  end

  test '920',
  'default disk is ExternalDisk' do
    assert_equal External::Disk, disk.class
  end

  # - - - - - - - - - - - - - - - - -

  test '1B1',
  'default shell is ExternalSheller' do
    assert_equal External::Sheller, shell.class
  end

end
