require_relative 'downloader_test_base'

class DownloaderTest < DownloaderTestBase

  def self.id58_prefix
    'Q96'
  end

  test '23J', %w( downloader ) do
    id = '5U2J18'
    tgz_filename, tgz_bytes = *downloader.download(id:id)
    assert_equal "cyber-dojo-2020-10-19-#{id}.tgz", tgz_filename
    disk.tmp_dir(id, '/tmp') do |tmp_dir|
      disk.write_bin("#{tmp_dir}/#{tgz_filename}", tgz_bytes)
      shell.assert_exec(
        "cd #{tmp_dir}",
        "tar -zxf #{tgz_filename}"
      )
      tags = shell.assert_exec(
        "cd #{tmp_dir}/cyber-dojo-2020-10-19-#{id}",
        "git tag"
      )
      assert_equal "0\n1\n2\n3\n", tags
      diff = shell.assert_exec(
        "cd #{tmp_dir}/cyber-dojo-2020-10-19-#{id}",
        "git diff 2 3"
      )
      assert diff.include?('-  echo $((6 * 999sss))'), diff
      assert diff.include?('+  echo $((6 * 7))'), diff
      ls_al = shell.assert_exec(
        "cd #{tmp_dir}/cyber-dojo-2020-10-19-#{id}/sandbox",
        "ls -al"
      )
      assert ls_al.include?('test_hiker.sh'), ls_al
      test_hiker_sh = disk.read_txt("#{tmp_dir}/cyber-dojo-2020-10-19-#{id}/sandbox/test_hiker.sh")
      assert test_hiker_sh.include?('source ./hiker.sh'), test_hiker_sh
    end
  end

end
