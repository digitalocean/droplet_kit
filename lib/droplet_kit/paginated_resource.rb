module DropletKit
  class PaginatedResource
    include Enumerable

    PER_PAGE = 20

    attr_reader :action, :connection, :cursor
    attr_accessor :total

    def initialize(action_connection, *args)
      @cursor = 0
      @total = nil
      @action = action_connection.action
      @connection = action_connection.connection
      @collection = []
      @args = args
    end

    def each
      retrieve_if_past_cursor

      return if self.total.zero?

      0.upto(self.total - 1) do |number|
        yield @collection[number]
        @cursor += 1
        retrieve_if_past_cursor
      end
    end

    private

    def retrieve_if_past_cursor
      if cursor >= @collection.size || total.nil?
        invoker = ResourceKit::ActionInvoker.new(action, connection, *@args)
        page = (cursor.to_f / PER_PAGE.to_f).ceil
        page = page > 0 ? page : 1
        invoker.options.merge!(page: page, per_page: PER_PAGE)

        @collection += invoker.handle_response

        if total.nil?
          meta = MetaInformation.extract_single(invoker.response.body, :read)
          self.total = meta.total.to_i
        end
      end
    end
  end
end