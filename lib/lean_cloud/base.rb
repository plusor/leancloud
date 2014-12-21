require 'lean_cloud'
require 'lean_cloud/helper'
require 'lean_cloud/client'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/object/blank'
require 'active_support/json/decoding'
require 'active_support/json/encoding'
module LeanCloud
  class Base
    class NotImplement < StandardError ; end

    class << self
      def register(klass, options={}, &block)
        klass = if !LeanCloud.const_defined?(klass, false)
          LeanCloud.const_set(klass, Class.new(self))
        else
          LeanCloud.const_get(klass)
        end

        klass.class_eval do
          include Helper

          cattr_accessor :routes, :namespace

          self.routes ||= []
          self.namespace = options[:namespace]

          class_exec(&block)
        end
      end

      def client(options={}, &block)
        Client.new(LeanCloud.config).instance(options,&block)
      end

      def dispatch(route, *args, &block)
        options = args.extract_options!
        data = parse_data(route, options)
        request = client(&route.block).send(route.request, route.url(*args), data, &block)
        LeanCloud.logger.info request.to_json
        parse_body(request)
      end

      def parse_data(route, data)
        if route.request == :get
          data
        elsif data.present?
          data.to_json
        end
      end

      def parse_body(request)
        JSON.parse(request.body) rescue request.body
      end
    end
  end
end
