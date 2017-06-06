shared_examples_for 'an action that handles invalid parameters' do
  let(:verb) { :post }
  let(:exception) { DropletKit::FailedCreate }

  it 'raises an exception with the message attached' do
    response_body = { id: :unprocessable_entity, message: 'Something is not right' }
    stub_do_api(path, verb).to_return(body: response_body.to_json, status: 422)

    expect { resource.send(action, arguments) }.to raise_exception(exception).with_message(response_body[:message])
  end
end
