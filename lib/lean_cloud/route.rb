module LeanCloud
  class Route
    attr_accessor :name, :request, :match, :options, :block
    def initialize(name, options, match=false, &block)
      options[:on] ||= :collection
      @name     = name
      @request  = options[:via] ||= :get
      @match    = match
      @options  = options
      @block    = block
    end

    def url(*args)
      namespace = options[:namespace] if !options[:unscope]
      id = args.shift                 if options[:on].to_sym == :member
      path = !match ? name.to_s : match.sub(/(:\w+)/, args[0].to_s) if !options[:root]
      [namespace, id, path].compact.join('/')
    end
  end
end