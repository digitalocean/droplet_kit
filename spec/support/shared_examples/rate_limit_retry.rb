# frozen_string_literal: true

shared_examples_for 'resource that handles rate limit retries' do
  let(:arguments) { {} }

  it 'handles rate limit' do
    response_body = { id: :rate_limit, message: 'example' }
    stub_do_api(path, method).to_return(
      [
        {
          body: nil,
          status: 429,
          headers: {
            'RateLimit-Limit' => 1200,
            'RateLimit-Remaining' => 1193,
            'RateLimit-Reset' => 1_402_425_459,
            'Retry-After' => 0 # Retry immediately in tests.
          }
        },
        {
          body: response_body.to_json,
          status: 200,
          headers: {
            'RateLimit-Limit' => 1200,
            'RateLimit-Remaining' => 1192,
            'RateLimit-Reset' => 1_402_425_459
          }
        }
      ]
    )

    expect { resource.send(action, arguments) }.not_to raise_error
  end
end
