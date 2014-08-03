require 'droplet_kit'
require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].each do |file|
  require file
end

RSpec.configure do |config|
  config.order = :random
  config.include RequestStubHelpers
end
