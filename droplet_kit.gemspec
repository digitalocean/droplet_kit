# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'droplet_kit/version'

Gem::Specification.new do |spec|
  spec.name          = "droplet_kit"
  spec.version       = DropletKit::VERSION
  spec.authors       = ["DigitalOcean API Engineering team"]
  spec.email         = ["api-engineering@digitalocean.com"]
  spec.summary       = %q{Droplet Kit is the official Ruby library for DigitalOcean's API}
  spec.description   = %q{Droplet Kit is the official Ruby library for DigitalOcean's API}
  spec.homepage      = "https://github.com/digitalocean/droplet_kit"
  spec.license       = "MIT"

  spec.files         = %w{LICENSE.txt README.md} + Dir.glob("lib/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'virtus', '~> 1.0.3'
  spec.add_dependency "resource_kit", '~> 0.1.5'
  spec.add_dependency "kartograph", '~> 0.2.8'
  spec.add_dependency "faraday", '>= 0.15'

  spec.add_development_dependency "bundler", ">= 2.1.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.9.0"
  spec.add_development_dependency "rb-readline"

  spec.add_development_dependency 'webmock', '~> 3.8.0'
end
