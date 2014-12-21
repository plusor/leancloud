require 'active_support/concern'
require 'lean_cloud/route'
module LeanCloud
  module Helper
    extend ActiveSupport::Concern

    module ClassMethods
      DEFAULT_ACTIONS = {
        :search =>  {via: :get,    root: true                 },
        :show   =>  {via: :get,    root: true,  on: :member   },
        :create =>  {via: :post,   root: true                 },
        :update =>  {via: :put,    root: true,  on: :member   },
        :destroy=>  {via: :delete, root: true,  on: :member   }
      }
      def only(*args)
        args.each do |action|
          add_route(action, DEFAULT_ACTIONS[action].dup)
        end
      end

      def route(name, options={})
        add_route(name, options)
      end

      def match(name, options={})
        raise "`as' can't be nil!" if !options[:as]
        add_route(options.delete(:as), options, name)
      end

      def add_route(name, options={},match=nil)
        options[:namespace] ||= namespace
        routes << Route.new(name, options, match)
      end

      def respond_to?(method_id)
        routes.any? {|route| route.name.to_s == method_id.to_s}
      end

      def method_missing(method_id, *args, &block)
        if route=routes.find {|route| route.name.to_s == method_id.to_s}
          dispatch(route, *args, &block)
        else
          super
        end
      end
    end
  end
end