# frozen_string_literal: true

module DropletKit
  class Links < BaseModel
    attribute :myself
    attribute :first
    attribute :next
    attribute :prev
    attribute :last
  end
end
