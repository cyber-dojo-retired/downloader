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

    def write_txt(pathed_filename, string)
      mkdir(pathed_filename)
      File.write(pathed_filename, string)
    end

    def write_bin(pathed_filename, bytes)
      mkdir(pathed_filename)
      File.binwrite(pathed_filename, bytes)
    end
    
    def read_txt(pathed_filename)
      File.read(pathed_filename)
    end
    
    def read_bin(pathed_filename)
      File.binread(pathed_filename)
    end
        
    private

    def mkdir(pathed_filename)
      dir_name = File.dirname(pathed_filename)
      shell.assert_exec("mkdir -vp #{dir_name}")      
    end
    
    def shell
      @externals.shell
    end

  end

end
