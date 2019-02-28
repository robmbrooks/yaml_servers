# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_servers/version'

Gem::Specification.new do |spec|
  spec.name          = "yaml_servers"
  spec.version       = YamlServers::VERSION
  spec.authors       = ["Robert Brooks"]
  spec.email         = ["robmbrooks@gmail.com"]

  spec.summary       = %q{yaml_servers creates a hash of server configs from yaml}
  spec.description   = %q{yaml_servers creates a hash of server config from yaml}
  spec.homepage      = "https://github.com/robmbrooks/yaml_servers"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'deep_merge', '~> 1.0', '>= 1.0.1'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
