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
    respond_to { |wants|
      wants.json {

      }
    }
  end

  get '/download_group', provides:[:json] do
    respond_to { |wants|
      wants.json {

      }
    }
  end


  def model
    externals.model
  end

end
