# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'droplet_kit/version'

Gem::Specification.new do |spec|
  spec.name          = "droplet_kit"
  spec.version       = DropletKit::VERSION
  spec.authors       = ["Robert Ross"]
  spec.email         = ["rross@digitalocean.com"]
  spec.summary       = %q{Droplet Kit is the official Ruby library for DigitalOcean's API}
  spec.description   = %q{Droplet Kit is the official Ruby library for DigitalOcean's API}
  spec.homepage      = "https://github.com/digitalocean/droplet_kit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'virtus', '~> 1.0.3'
  spec.add_dependency "resource_kit", '~> 0.1.5'
  spec.add_dependency "kartograph", '~> 0.2.3'
  spec.add_dependency "activesupport", '> 3.0', '< 6'
  spec.add_dependency "faraday", '~> 0.9'

  spec.add_development_dependency "bundler", ">= 1.11.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rb-readline"

  # FakeServe
  spec.add_development_dependency 'sinatra', '~> 1.4'
  spec.add_development_dependency 'webmock', '~> 1.18'
end
