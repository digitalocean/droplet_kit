require 'simplecov'

SimpleCov.start

require 'faraday'
require 'addressable/uri'
require 'droplet_kit'
require 'webmock/rspec'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(SimpleCov::Formatter::HTMLFormatter)

Dir['./spec/support/**/*.rb'].each do |file|
  require file
end

RSpec.configure do |config|
  config.order = :random
  config.include RequestStubHelpers
end
