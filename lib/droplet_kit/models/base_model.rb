require 'virtus'

module DropletKit
  class BaseModel
    include Virtus.model
    include Virtus::Equalizer.new(name || inspect)
  end
end