module RequestStubHelpers
  def stub_do_api(path, verb = :any)
    stub_request(verb, %r[#{DropletKit::Client::DIGITALOCEAN_API}#{path}])
  end

  def api_fixture(fixture_name)
    Pathname.new('./spec/fixtures/').join("#{fixture_name}.json").read
  end
end