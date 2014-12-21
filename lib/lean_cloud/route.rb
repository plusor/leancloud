module LeanCloud
  class Route
    attr_accessor :name, :request, :match, :options
    def initialize(name, options, match=false)
      options[:on] ||= :collection
      @name     = name
      @request  = options[:via] ||= :get
      @match    = match
      @options  = options
    end

    def url(*args)
      namespace = options[:namespace] if !options[:unscope]
      id = args.shift                 if options[:on].to_sym == :member
      path = !match ? name.to_s : match.sub(/(:\w+)/, args[0]) if !options[:root]
      [namespace, id, path].compact.join('/')
    end
  end
end