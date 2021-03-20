# frozen_string_literal: true

class Downloader

  def initialize(externals)
    @externals = externals
  end

  def download_kata(id:)
    #...
  end

  def download_group(id:)
    #...
  end

  private

  def model
    @externals.model
  end

end
