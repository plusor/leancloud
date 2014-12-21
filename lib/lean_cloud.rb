require 'lean_cloud/modules'
require 'lean_cloud/configuration'
module LeanCloud
  class << self

    def configure(&block)
      class_exec(&block)
    end
  
    def config
      @config ||= Configuration.instance
    end
  end

  def config
    self.class.config
  end
end
