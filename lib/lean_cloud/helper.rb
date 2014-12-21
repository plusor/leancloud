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

      def route(name, options={}, &block)
        add_route(name, options, &block)
      end

      def match(name, options={}, &block)
        raise "`as' can't be nil!" if !options[:as]
        add_route(options.delete(:as), options, name, &block)
      end

      def add_route(name, options={},match=nil, &block)
        options[:namespace] ||= namespace
        route = Route.new(name, options, match, &block)
        define_singleton_method(name) {|*args, &block| dispatch(route, *args, &block) }
        routes << route
      end
    end
  end
end