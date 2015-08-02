module DropletKit
  # PaginatedResource provides an Enumerable interface to external resource,
  # fetching elements as needed.
  #
  # #each is able to start at specified index, i.e. #each(5) will start yielding
  # elements starting at 6th element.
  class PaginatedResource
    include Enumerable

    PER_PAGE = 20

    attr_reader :action, :resource, :fetched_elements

    def initialize(action, resource, *args)
      @action = action
      @resource = resource
      @args = args

      @options = args.last.kind_of?(Hash) ? args.last : {}
      @last_fetched_page = 0
      @fetched_elements = []
    end

    def per_page
      @options[:per_page] || PER_PAGE
    end

    def each(start = 0)
      return to_enum(:each, start) unless block_given?

      # Start off with the first page if we have no idea of anything yet
      fetch_next_page if nothing_fetched_yet?
      Array(@fetched_elements[start..-1]).each do |element|
        yield(element)
      end

      if more_pages_to_fetch?
        start = [@fetched_elements.size, start].max
        fetch_next_page
        each(start, &Proc.new)
      end

      self
    end

    def total_pages
      return nil if nothing_fetched_yet?

      (@total_remote_elements.to_f / per_page.to_f).ceil
    end

    def ==(other)
      each_with_index.each.all? {|object, index| object == other[index] }
    end

    private

    def fetch_next_page
      @last_fetched_page += 1
      retrieve(@last_fetched_page)
    end

    def more_pages_to_fetch?
      @last_fetched_page < total_pages && @total_remote_elements > 0
    end

    def nothing_fetched_yet?
      @total_remote_elements.nil?
    end

    def retrieve(page, per_page = self.per_page)
      invoker = ResourceKit::ActionInvoker.new(action, resource, *@args)
      invoker.options[:per_page] ||= per_page
      invoker.options[:page]       = page

      @fetched_elements += invoker.handle_response

      if nothing_fetched_yet?
        meta = MetaInformation.extract_single(invoker.response.body, :read)
        @total_remote_elements = meta.total.to_i
      end
    end
  end
end
