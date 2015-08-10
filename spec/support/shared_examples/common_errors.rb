shared_examples_for 'resource that handles common errors' do
  let(:arguments) { {} }

  it 'handles rate limit' do
    response_body = { id: :rate_limit, message: 'Too much!!!' }
    stub_do_api(path, method).to_return(body: response_body.to_json, status: 429, headers: {
      'RateLimit-Limit' => 1200,
      'RateLimit-Remaining' => 1193,
      'RateLimit-Reset' => 1402425459,
    })

    expect { resource.send(action, arguments).to_a }.to raise_exception(DropletKit::Error) do |exception|
      expect(exception.message).to match /#{response_body[:message]}/
      expect(exception.limit).to eq 1200
      expect(exception.remaining).to eq 1193
      expect(exception.reset_at).to eq "1402425459"
    end
  end

  it 'handles unauthorized' do
    response_body = { id: :unauthorized, message: 'Nuh uh.' }

    stub_do_api(path, method).to_return(body: response_body.to_json, status: 401)

    expect { resource.send(action, arguments).to_a }.to raise_exception(DropletKit::Error).with_message(/#{response_body[:message]}/)
  end
end