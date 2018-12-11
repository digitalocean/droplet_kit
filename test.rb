require 'pry'
require 'droplet_kit'

token = '0e833ebb5c6b914eb58586ac14b03166bfd41110904e433e99e926abc6262bd2'
client = DropletKit::Client.new(access_token: token)

binding.pry
client

