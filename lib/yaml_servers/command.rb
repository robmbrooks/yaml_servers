# -*- mode: ruby -*-
# vi: set ft=ruby :

module YamlServers
  class Command < Vagrant.plugin('2', :command)

    def execute
      config = @env.config_loader.load([:default, :home, :root])[0]
      yaml_servers = { "servers" => config.yamlservers.servers }
      @env.ui.info yaml_servers.to_yaml
      0
    end

    def self.synopsis
      'show rendered yaml config'
    end
  end
end
