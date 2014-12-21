require 'faraday'
module LeanCloud
  class Configuration
    class << self
      private :new
      def instance
        @instance ||= new
      end
    end

    def initialize
      @@options = {
        :http_adapter => Faraday,
        :app_id       => nil,
        :app_key      => nil
      }
    end

    def respond_to?(name, include_private = false)
      super || @@options.key?(name.to_sym)
    end

    private

    def method_missing(name, *args, &blk)
      if name.to_s =~ /=$/
        @@options[$`.to_sym] = args.first
      elsif @@options.key?(name)
        @@options[name]
      else
        super
      end
    end
  end
end
