# frozen_string_literal: true
require_relative 'external/disk'
require_relative 'external/http'
require_relative 'external/model'
require_relative 'external/sheller'

class Externals

  def disk
    @disk ||= External::Disk.new
  end

  def shell
    @shell ||= External::Sheller.new
  end

  # - - - - - - - - - - - - - - - - -

  def model
    @model ||= External::Model.new(self)
  end
  def model_http
    @model_http ||= External::Http.new
  end

end
