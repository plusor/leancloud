require 'lean_cloud/modules'
require 'lean_cloud/configuration'
require 'logger'
module LeanCloud
  class << self

    def configure(&block)
      class_exec(&block)
    end
  
    def config
      @config ||= Configuration.instance
    end

    def logger
      if defined?(Rails)
        Rails.logger
      else
        Logger.new(STDOUT)
      end
    end
  end

  def config
    self.class.config
  end
end
