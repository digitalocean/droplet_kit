# frozen_string_literal: true

shared_examples_for 'resource that handles common errors' do
  let(:arguments) { {} }

  it 'handles unauthorized' do
    response_body = { id: :unauthorized, message: 'Nuh uh.' }

    stub_do_api(path, method).to_return(body: response_body.to_json, status: 401)

    expect { resource.send(action, arguments).to_a }.to raise_exception(DropletKit::Error).with_message(/#{response_body[:message]}/)
  end
end
