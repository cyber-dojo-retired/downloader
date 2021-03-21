# frozen_string_literal: true

module External

  class Disk

    def tmp_dir(key, path)
      Dir.mktmpdir(key, path) do |dir|
        yield dir
      end
    end

    def write(pathed_filename, content)
      File.open(pathed_filename, 'w') { |fd| fd.write(content) }
    end

    def binread(pathed_filename)
      File.binread(pathed_filename)
    end

  end

end
