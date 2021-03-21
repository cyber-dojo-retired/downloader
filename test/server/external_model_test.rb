require_relative 'downloader_test_base'

class ExternalModelTest < DownloaderTestBase

  def self.id58_prefix
    '23F'
  end

  test 'qKd', %w( model.kata_exists?(id) true ) do
    assert model.kata_exists?('5U2J18').is_a?(TrueClass)
  end

  test 'qKe', %w( model.kata_exists?(id) false ) do
    assert model.kata_exists?('123456').is_a?(FalseClass)
  end

end
