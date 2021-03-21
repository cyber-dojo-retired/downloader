require_relative 'downloader_test_base'

class ExternalShellerTest < DownloaderTestBase

  def self.id58_prefix
    'C89'
  end

  test 'DBB',
  'assert_exec(*commands) returns stdout when the commands all succeed' do
    assert_equal 'Hello', shell.assert_exec('echo -n Hello')
    assert_equal 'bonjour', shell.assert_exec('true', 'echo -n bonjour')
  end

  test 'AF6',
  'assert_exec(*commands) raises when a command fails' do
    error = assert_raises { shell.assert_exec('zzzz') }
    json = JSON.parse(error.message)
    assert_equal '', json['stdout']
    # depending on host could be sh or /bin/sh
    assert json['stderr'].end_with?("sh: zzzz: not found\n")
    assert_equal 127,  json['exit_status']
  end

end
