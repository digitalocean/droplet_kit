module RequestStubHelpers
  def stub_do_api(path, verb = :any)
    stub_request(verb, %r[#{DropletKit::Client::DIGITALOCEAN_API}#{Regexp.escape(path)}])
  end

  def api_fixture(fixture_name)
    Pathname.new('./spec/fixtures/').join("#{fixture_name}.json").read
  end

  def stub_pager_request(total_results = 40)
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/droplets') do |env|
        request_count.count += 1
        uri = Addressable::URI.parse(env[:url].to_s)
        page = (uri.query_values['page'] || 1).to_i
        per_page = (uri.query_values['per_page'] || 20).to_i

        max_elems = [total_results, per_page].min

        range = (0...max_elems).map do |num|
          num + ((page - 1) * per_page)
        end

        [200, {}, { objects: range, meta: { total: total_results } }.to_json ]
      end
    end
  end
end
