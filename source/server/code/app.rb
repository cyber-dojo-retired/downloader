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

  get_prober(:sha)
  get_prober(:alive?)
  get_prober(:ready?)

  get_octet_stream(:download_kata)
  get_octet_stream(:download_group)

end
