require 'droplet_kit'

namespace :doc do
  task :resources do
    resources = DropletKit::Client.resources

    resources.each do |key, klass|
      puts "## #{klass.name.demodulize.underscore.humanize}"
      puts
      puts "    client = DropletKit::Client.new(access_token: 'TOKEN')"
      puts "    client.#{key} #=> #{klass.name}"
      puts
      puts "Actions supported: "
      puts
      klass._resources.each do |action|
        puts " * `#{action.name}`"
      end
      puts
      puts
    end
  end
end