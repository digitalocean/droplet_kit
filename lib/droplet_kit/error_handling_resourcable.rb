# frozen_string_literal: true

module ErrorHandlingResourcable
  def self.included(base)
    base.send(:resources) do
      default_handler do |response|
        case response.status
        when 200...299
          next
        when 429
          error = DropletKit::RateLimitReached.new("#{response.status}: #{response.body}")
          error.limit = response.headers['RateLimit-Limit']
          error.remaining = response.headers['RateLimit-Remaining']
          error.reset_at = response.headers['RateLimit-Reset']
          raise error
        else
          raise DropletKit::Error.new("#{response.status}: #{response.body}")
        end
      end
    end
  end
end
