# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'active_support'
require 'active_support/core_ext'
require 'getoptlong'
require 'resolv'
require 'yaml'
require "yaml_servers/version"

module YamlServers
  def self.apply_defaults(config, defaults)
    # merge defaults
    config = defaults.deep_merge(config)

    # apply defaults to each server
    servers = {}
    config["servers"].each { |hostname, server|
      servers[hostname] = config["default"].deep_merge(server.is_a?(Hash) ? server : { })
      servers[hostname]["is_primary"] = (hostname == config["primary"])
      if servers[hostname].key?("ip") then
        begin
          servers[hostname]["ip"] = Resolv.new.getaddresses(server["ip"])[0]
        rescue => err
          STDERR.puts err
          servers[hostname]["ip"] = server["ip"]
        end
      end
      servers[hostname]["inline"] = servers[hostname]["inline"].lines.to_a if servers[hostname]["inline"].is_a?(String)
    } if config.key?("servers")

    return servers
  end

  def self.get_yaml(file, missing_ok)
    if missing_ok then
      return {} unless File.file?(file)
    end

    begin
      yaml = YAML::load(File.read(file))
    rescue => err
      STDERR.puts "Warning: #{file} not available"
      STDERR.puts err
    end

    # if our config is not a hash we assume it is a list of servers
    if yaml and !yaml.is_a?(Hash) then
      begin
        return { "servers" => Hash[yaml.to_a.map {|server| server.is_a?(Hash) ? server.flatten : [server.to_str,nil]}] }
      rescue => err
        STDERR.puts err
        return {}
      end
    elsif yaml.is_a?(Hash) and !yaml.key?("servers") and !missing_ok
      yaml = { "servers" => yaml }
    end
    return yaml ? yaml : {}
  end

  def self.get_config(path, defaults = {}, yaml_configs = [], localconf = "local.yaml")
    # get data from local.yaml
    local_config = get_yaml("#{path}/#{localconf}",true)

    # get additional configs set as include in local config
    yaml_configs = yaml_configs | (local_config.key?("include") ? local_config["include"] : [])

    # collect servers from each yaml file applying defaults
    servers = {}
    config = {}
    yaml_configs.each do |yaml|
      config = get_yaml("#{path}/#{yaml}",false)

      # merge localconf defaults over top of lower precedence defaults
      config = config.deep_merge(local_config.reject { |key| key == "servers"} )

      # get servers from config
      servers.merge!(apply_defaults(config, defaults))
    end

    # build new config hash with servers collected above and local config applied
    config = { "servers" => servers, "primary" => config["primary"] }
    config = defaults.deep_merge(config)
    config = config.deep_merge(local_config)

    # we need at least one server
    config["servers"] = { "default" => nil }  unless config.key?("servers")

    # final rendering
    return apply_defaults(config, defaults)
  end

  def self.get_provider_opt(default = false)
    opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--provider', GetoptLong::OPTIONAL_ARGUMENT ]
    )
    opts.quiet = true

    provider = default
    begin
      opts.each do |opt, arg|
        case opt
        when '--provider'
          if arg
            provider=arg
          end
        end
      end
    rescue => err
    end
    return provider
  end
end