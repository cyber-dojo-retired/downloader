# frozen_string_literal: true
require_relative '../id58_test_base'
require_source 'app'
require_source 'externals'
require 'cgi'
require 'json'
require 'ostruct'

class DownloaderTestBase < Id58TestBase

  include Rack::Test::Methods # [1]

  def app # [1]
    App.new(externals)
  end

  def externals
    @externals ||= Externals.new
  end

  def prober
    @prober ||= Prober.new(externals)
  end

  def downloader
    @downloader ||= Downloader.new(externals)
  end

  def disk
    externals.disk
  end

  def model
    externals.model
  end

  def shell
    externals.shell
  end

  # - - - - - - - - - - - - - - -

  def group_exists?(id)
    model.group_exists?(id)
  end

  def group_manifest(id)
    model.group_manifest(id)
  end

  # - - - - - - - - - - - - - - -

  def kata_exists?(id)
    model.kata_exists?(id)
  end

  def kata_manifest(id)
    model.kata_manifest(id)
  end

  def kata_events(id)
    model.kata_events(id)
  end

  def kata_event(id, index)
    model.kata_event(id, index)
  end

end
