# frozen_string_literal: true

module DropletKitHelpers
  BLANK_RE = /\A[[:space:]]*\z/

  def self.presence(object)
    case object
    when String then !object.empty? || BLANK_RE !~ object
    else !!object
    end
  end
end

RSpec::Matchers.define :be_present do
  match do |actual|
    DropletKitHelpers.presence(actual)
  end
end

RSpec::Matchers.define :be_blank do
  match do |actual|
    !DropletKitHelpers.presence(actual)
  end
end
