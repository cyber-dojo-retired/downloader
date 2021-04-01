require_relative 'downloader_test_base'
require_relative 'tarfile_reader'
require 'tmpdir'

class SpikeTest < DownloaderTestBase

  def self.id58_prefix
    '1H8'
  end

  test '19e', %w( spike ) do
    Dir.mktmpdir do |dir|
      @dir = dir
      cd_exec('git init')
      cd_exec("git config user.name 'spike'")
      cd_exec("git config user.email 'spike@cyber-dojo.org'")
      write_txt('aaa.txt', 'aaa')
      write_txt('s/pike/bbb.txt', 'bbb')
      cd_exec('git add .')
      cd_exec("git commit -m '1'")
      cd_exec('git tag 1')
      tar = cd_exec("git archive --format=tar 1")
      reader = TarFile::Reader.new(tar)
      files = reader.files.each.with_object({}) do |(path,content),memo|
        if path == 'pax_global_header'
          next
        end
        if path.end_with?('/')
          next
        end
        memo[path] = content
      end
      assert_equal ['aaa.txt', 's/pike/bbb.txt'], files.keys.sort
      assert_equal 'aaa', files['aaa.txt']
      assert_equal 'bbb', files['s/pike/bbb.txt']
    end
  end

  private

  def cd_exec(*commands)
    shell.assert_cd_exec(@dir, *commands)
  end

  def write_txt(filename, txt)
    disk.write_txt("#{@dir}/#{filename}", txt)
  end

end
