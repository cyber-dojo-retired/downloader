# frozen_string_literal: true
require_relative 'downloader'
require_relative 'prober'
require_relative 'http_json_hash/service'
require 'sinatra/base'
require_relative 'silently'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require 'json'
require 'sprockets'


class AppBase < Sinatra::Base

  def initialize(externals)
    @externals = externals
    super(nil)
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']
  set :environment, Sprockets::Environment.new

  private

  def self.get_prober(name)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = prober.public_send(name, **json_args)
          json({ name => result })
        }
      end
    end
  end

  def self.get_octet_stream(name)
    get "/#{name}" do
      tgz_name, tgz_bytes = *downloader.public_send(name, **json_args)
      response.headers['content_type'] = "application/octet-stream"
      attachment(tgz_name)
      response.write(tgz_bytes)
    end
  end

  def prober
    Prober.new(@externals)
  end

  def downloader
    Downloader.new(@externals)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def json_args
    @json_args ||= symbolized(json_payload)
  end

  def symbolized(h) # named-args require symbolization
    Hash[h.map{ |key,value| [key.to_sym, value] }]
  end

  def json_payload
    json_hash_parse(request.body.read)
  end

  def json_hash_parse(body)
    json = (body === '') ? {} : JSON.parse!(body)
    unless json.instance_of?(Hash)
      fail 'body is not JSON Hash'
    end
    json
  rescue JSON::ParserError
    fail 'body is not JSON'
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  set :show_exceptions, false

  error do
    error = $!
    info = {
      exception: {
        request: {
          path:request.path,
          body:request.body.read
        },
        backtrace: error.backtrace
      }
    }
    exception = info[:exception]
    if error.instance_of?(::HttpJsonHash::ServiceError)
      exception[:http_service] = {
        path:error.path,
        args:error.args,
        name:error.name,
        body:error.body,
        message:error.message
      }
    else
      exception[:message] = error.message
    end
    puts JSON.pretty_generate(info)
    halt erb :error
  end

end
