module YamlServers
  class Config < Vagrant.plugin('2', :config)
    attr_accessor :servers

    def initialize
      @servers                  = { }
    end
  end
end
