# frozen_string_literal: true
require_relative 'app_base'
require_relative 'downloader'
require_relative 'prober'

class App < AppBase

  def initialize(externals)
    super(externals)
    @externals = externals
  end

  attr_reader :externals

  def downloader
    Downloader.new(externals)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  get_delegate(Prober, :sha)
  get_delegate(Prober, :alive?)
  get_delegate(Prober, :ready?)

  # - - - - - - - - - - - - - - - - - - - - -

  get '/download_kata', provides:[:json] do
    name = 'download_kata'
    respond_to { |wants|
      wants.json {
        Dir.mktmpdir(id, '/tmp') do |tmp_dir|
          args = json_args
          args[:tmp_dir] = tmp_dir
          result = { name => downloader.public_send(name, **args) }
          json(result)
        end
      }
    }
  end

  get '/download_group', provides:[:json] do
    name = 'download_group'
    respond_to { |wants|
      wants.json {
        Dir.mktmpdir(id, '/tmp') do |tmp_dir|
          args = json_args
          args[:tmp_dir] = tmp_dir
          result = { name => downloader.public_send(name, **args) }
          json(result)
        end
      }
    }
  end

end
