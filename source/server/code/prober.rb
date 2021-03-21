# frozen_string_literal: true

class Prober

  def initialize(externals)
    @externals = externals
  end

  def sha(_args)
    ENV['SHA']
  end

  def alive?(_args)
    true
  end

  def ready?(_args)
    @externals.model.ready?
  end

end
