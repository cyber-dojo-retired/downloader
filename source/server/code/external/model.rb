# frozen_string_literal: true
require_relative '../http_json_hash/service'

module External

  class Model

    def initialize(externals)
      hostname = 'model'
      @port = ENV[port_env_var].to_i
      @http = HttpJsonHash::service(self.class.name, externals.model_http, hostname, port)
    end

    attr_reader :port

    def ready?
      @http.get(__method__, {})
    end

    # - - - - - - - - - - - - - - - - - - -

    def kata_exists?(id)
      @http.get(__method__, { id:id })
    end

    def kata_manifest(id)
      @http.get(__method__, { id:id })
    end

    def kata_events(id)
      @http.get(__method__, { id:id })
    end

    def kata_event(id, index)
      @http.get(__method__, { id:id, index:index })
    end

  private

    def port_env_var
      docker_port_env_var
    end

=begin
    def port_env_var
      if ENV.has_key?(k8s_port_env_var)
        k8s_port_env_var
      else
        docker_port_env_var
      end
    end

    def k8s_port_env_var
      'CYBER_DOJO_K8S_PORT'
    end
=end

    def docker_port_env_var
      'CYBER_DOJO_MODEL_PORT'
    end

  end

end
