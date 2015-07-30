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
    attr_accessor :total_remote_elements

    def initialize(action, resource, *args)
      @last_fetched_page = 0
      @total_remote_elements = nil
      @action = action
      @resource = resource
      @fetched_elements = []
      @args = args
      @options = args.last.kind_of?(Hash) ? args.last : {}
    end

    def per_page
      @options[:per_page] || PER_PAGE
    end

    def each(start = 0)
      # Start off with the first page if we have no idea of anything yet
      fetch_next_page if total_remote_elements.nil?

      return to_enum(:each, start) unless block_given?
      Array(@fetched_elements[start..-1]).each do |element|
        yield(element)
      end

      unless last?
        start = [@fetched_elements.size, start].max
        fetch_next_page
        each(start, &Proc.new)
      end

      self
    end

    def last?
      @last_fetched_page == total_pages || self.total_remote_elements.zero?
    end

    def total_pages
      return nil if self.total_remote_elements.nil?

      (self.total_remote_elements.to_f / per_page.to_f).ceil
    end

    def ==(other)
      each_with_index.each.all? {|object, index| object == other[index] }
    end

    private

    def fetch_next_page
      @last_fetched_page += 1
      retrieve(@last_fetched_page)
    end

    def retrieve(page, per_page = self.per_page)
      invoker = ResourceKit::ActionInvoker.new(action, resource, *@args)
      invoker.options[:per_page] ||= per_page
      invoker.options[:page]       = page

      @fetched_elements += invoker.handle_response

      if total_remote_elements.nil?
        meta = MetaInformation.extract_single(invoker.response.body, :read)
        self.total_remote_elements = meta.total.to_i
      end
    end
  end
end
