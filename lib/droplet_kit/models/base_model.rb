require 'virtus'

module DropletKit
  class BaseModel
    DO_NAMESPACE = 'do'
    UNSUPPORTED_COLLECTIONS = ['space']

    include Virtus.model
    include Virtus::Equalizer.new(name || inspect)

    def inspect
      values = Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
      "<#{self.class.name} #{values}>"
    end

    def urn
      "#{DO_NAMESPACE}:#{collection_name}:#{identifier}"
    end

    def collection_name
      self.class.name.split('::').last.underscore
    end

    def identifier
      identifier = attributes[:id] || attributes[:uuid] || attributes[:slug]
      raise DropletKit::Error.new("#{self.class.name} doesn't support URNs") if identifier.nil?

      identifier
    end

    def self.valid_urn?(urn)
      parts = urn.split(':')
      return false if parts.size != 3 || parts[0] != DO_NAMESPACE

      collection = parts[1]
      return true if UNSUPPORTED_COLLECTIONS.include?(collection)

      begin
        "DropletKit::#{collection.camelize}".constantize
      rescue NameError
        return false
      end

      true
    end

    def self.from_urn(urn)
      DropletKit::Error.new("Invalid urn: #{urn}") unless valid_urn?(urn)

      parts = urn.split(':')
      collection = parts[1]
      identifier = parts[2]

      return nil if UNSUPPORTED_COLLECTIONS.include?(collection)

      klass = "DropletKit::#{collection.camelize}".constantize
      klass.from_identifier(identifier)
    end

    def self.from_identifier(identifier)
      new(id: identifier)
    end
  end
end