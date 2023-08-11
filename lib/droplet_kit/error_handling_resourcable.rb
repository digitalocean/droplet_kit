# frozen_string_literal: true

module ErrorHandlingResourcable
  def self.included(base)
    base.send(:resources) do
      default_handler do |response|
        case response.status
        when 200...299
          next
        else
          raise DropletKit::Error, "#{response.status}: #{response.body}"
        end
      end
    end
  end
end
