require 'droplet_kit'
require 'droplet_kit/utils'

namespace :doc do
  task :resources do
    resources = DropletKit::Client.resources

    resources.each do |key, klass|
      if (ENV['SKIP_CLASSES'] || '').split(',').include?(klass.name)
        next
      end

      class_name = DropletKit::Utils.underscore klass.name.split('::'.freeze).last
      human_name = class_name.dup
      human_name.tr!('_'.freeze, ' '.freeze)
      human_name.gsub!(/([a-z\d]*)/i) { |match| match.downcase }
      human_name.gsub!(/\A\w/) { |match| match.upcase }

      puts "## #{human_name}"
      puts
      puts "    client = DropletKit::Client.new(access_token: 'TOKEN')"
      puts "    client.#{key} #=> #{klass.name}"
      puts
      puts "Actions supported: "
      puts
      klass._resources.each do |action|
        action_options = action.path.scan(/\:[\w_\-]+/i)
        params = []

        if action.body && action.body.arity > 0
          resource = class_name.dup
          resource.gsub!('_resource', '')
          resource.downcase!
          params << resource
        end

        if action_options.any?
          action_string = action_options.map do |option|
            option.gsub!(/^\:/, '')
            "#{option}: '#{option}'"
          end.join(', ')

          params << action_string
        end

        puts "* `client.#{key}.#{action.name}(#{params.join(', ')})`"
      end
      puts
      puts
    end
  end
end
