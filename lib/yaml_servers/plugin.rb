# -*- mode: ruby -*-
# vi: set ft=ruby :

module YamlServers
  class Plugin < Vagrant.plugin('2')
    name "YamlServers"

    command 'yaml-config' do
      require_relative 'command'
      Command
    end

    config 'yamlservers' do
      require_relative 'config'
      Config
    end
  end
end
