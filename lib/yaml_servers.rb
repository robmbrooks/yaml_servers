# -*- mode: ruby -*-
# vi: set ft=ruby :

begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant yaml_servers plugin must be run within Vagrant.'
end

require 'active_support'
require 'active_support/core_ext'
require 'getoptlong'
require 'resolv'
require 'yaml'
require "yaml_servers/command"
require "yaml_servers/config"
require "yaml_servers/plugin"
require "yaml_servers/read_yaml"
require "yaml_servers/version"
