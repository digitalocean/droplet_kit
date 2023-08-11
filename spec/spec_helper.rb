# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

require 'faraday'
require 'faraday/retry'
require 'addressable/uri'
require 'droplet_kit'
require 'webmock/rspec'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(SimpleCov::Formatter::HTMLFormatter)

Dir['./spec/support/**/*.rb'].sort.each do |file|
  require file
end

RSpec.configure do |config|
  config.order = :random
  config.include RequestStubHelpers
end
