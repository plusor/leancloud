require 'lean_cloud/version'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/module/delegation'
module LeanCloud
  class Client

    attr_accessor :options

    delegate :app_id, :app_key, :master_key, :version, :http_adapter, :host, to: :options
    delegate :get, :put, :post, :delete, to: :instance

    def initialize(options)
      @options = LeanCloud.config.dup.merge(options)
    end

    def adapter
      http_adapter
    end

    def instance(options={}, &block)
      adapter.new(url, headers: headers, &block)
    end

    def headers(options={})
      {
        "X-AVOSCloud-Application-Id"  => app_id,
        "X-AVOSCloud-Application-Key" => app_key,
        "X-AVOSCloud-Master-Key"      => master_key,
        'Content-Type'                => 'application/json',
        'User-Agent'                  => "LeanCloud SDK Ruby / #{LeanCloud::VERSION}"
      }.merge(options)
    end

    def url
      [host, version].join('/')
    end
  end
end