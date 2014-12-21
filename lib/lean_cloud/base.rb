require 'lean_cloud'
require 'lean_cloud/helper'
require 'lean_cloud/client'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/json/decoding'
require 'active_support/json/encoding'
module LeanCloud
  class Base
    class NotImplement < StandardError ; end

    class << self
      def register(klass, options={}, &block)
        klass = if !LeanCloud.const_defined?(klass)
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

      def client
        Client.new(LeanCloud.config).instance
      end

      def dispatch(route, *args, &block)
        options = args.extract_options!
        client.send(route.request, route.url(*args), options.to_json, &block)
      end
    end
  end
end
