# To use this, `fixture_path`, `api_path` and a `resource` must be defined
# using `let`s.
shared_examples_for 'a paginated index' do
  let(:fixture_path) { }
  let(:api_path) { }
  let(:parameters) { {} }
  let(:action) { :all }

  it 'returns a paginated resource' do
    fixture = api_fixture(fixture_path)
    stub_do_api(api_path, :get).to_return(body: fixture)
    response = resource.send(action, {page: 1, per_page: 1}.merge(parameters))

    expect(response).to be_kind_of(DropletKit::PaginatedResource)
  end
end
