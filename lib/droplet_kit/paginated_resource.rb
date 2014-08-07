module DropletKit
  class PaginatedResource
    include Enumerable

    PER_PAGE = 20

    attr_reader :action, :connection, :cursor
    attr_accessor :total

    def initialize(action_connection, *args)
      @current_page = 1
      @total = nil
      @action = action_connection.action
      @connection = action_connection.connection
      @collection = []
      @args = args

      # Start off with the first page
      retrieve(1)
    end

    def each(start = 0)
      return to_enum(:each, start) unless block_given?
      Array(@collection[start..-1]).each do |element|
        yield(element)
      end

      unless last?
        start = [@collection.size, start].max
        fetch_next_page
        each(start, &Proc.new)
      end

      self
    end

    def last?
      @current_page == (self.total.to_f / PER_PAGE.to_f).ceil
    end

    def ==(other)
      return false if self.total != other.length
      each_with_index.each.all? {|object, index| object == other[index] }
    end

    private

    def fetch_next_page
      retrieve(@current_page)
      @current_page += 1
    end

    def retrieve(page, per_page = PER_PAGE)
      invoker = ResourceKit::ActionInvoker.new(action, connection, *@args)
      invoker.options.merge!(page: page, per_page: PER_PAGE)
      @collection += invoker.handle_response

      if total.nil?
        meta = MetaInformation.extract_single(invoker.response.body, :read)
        self.total = meta.total.to_i
      end
    end
  end
end