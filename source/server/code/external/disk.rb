# frozen_string_literal: true

module External

  class Disk

    def initialize(externals)
      @externals = externals
    end

    def tmp_dir(key, tmp_path)
      Dir.mktmpdir(key, tmp_path) do |dir|
        yield dir
      end
    end

    def write(pathed_filename, content)
      dir = File.dirname(pathed_filename)
      shell.assert_exec("mkdir -vp #{dir}")
      File.open(pathed_filename, 'w') do |file|
        file.write(content)
      end
    end

    def binread(pathed_filename)
      File.binread(pathed_filename)
    end

    private

    def shell
      @externals.shell
    end

  end

end
