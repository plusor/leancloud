require 'faraday'
module LeanCloud
  class Configuration < Hash
    class << self
      private :new
      def instance
        @instance ||= new
      end
    end

    def initialize
      {
        :http_adapter => Faraday,
        :app_id       => nil,
        :app_key      => nil
      }.each {|k, v| self[k] = v}
    end

    def respond_to?(name, include_private = false)
      super || key?(name.to_sym)
    end

    private

    def method_missing(name, *args, &blk)
      if name.to_s =~ /=$/
        self[$`.to_sym] = args.first
      elsif self.key?(name)
        self[name]
      else
        super
      end
    end
  end
end
