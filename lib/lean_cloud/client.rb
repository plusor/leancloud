require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/module/delegation'
module LeanCloud
  class Client

    attr_accessor :options

    delegate :app_id, :app_key, :version, :http_adapter, :host, to: :options
    delegate :get, :put, :post, :delete, to: :instance

    def initialize(options)
      @options = options
    end

    def adapter
      http_adapter
    end

    def instance
      adapter.new(url, headers: headers)
    end

    def headers
      {"X-AVOSCloud-Application-Id" => app_id, "X-AVOSCloud-Application-Key" => app_key, 'Content-Type' => 'application/json' }
    end

    def url
      [host, version].join('/')
    end
  end
end