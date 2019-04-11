require 'spec_helper'

describe Fulcrum::Client do
  let(:client) { Fulcrum::Client.new }

  it 'has a default url' do
    expect(client.url).to eq(Fulcrum::Client::DEFAULT_URL)
  end

  it 'can query' do
    url = "#{client.url}/query"
    response = 'audio,system,,,,,'

    stub_request(:post, url)
      .with(body: '{"q":"select name from tables limit 1;","format":"csv"}')
      .to_return(status: 200, body: response,
                 headers: {"Content-Type" => "text/plain"})

    sql = 'select name from tables limit 1;'
    csv = client.query(sql, 'csv')

    expect(csv).to eq(response)
  end
end
