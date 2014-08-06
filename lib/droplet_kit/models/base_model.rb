require 'virtus'

module DropletKit
  class BaseModel
    include Virtus.model
    include Virtus::Equalizer.new(name || inspect)

    def inspect
      values = Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
      "<#{self.class.name} #{values}>"
    end
  end
end