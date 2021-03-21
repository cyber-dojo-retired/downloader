# frozen_string_literal: true
require_relative 'app_base'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

  get_prober(:sha)
  get_prober(:alive?)
  get_prober(:ready?)

  get_octet_stream(:download)

end
