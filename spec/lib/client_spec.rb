require 'spec_helper'

describe Fulcrum::Client do
  let(:client) { Fulcrum::Client.new }

  it 'has a default url' do
    client.url.should eq(Fulcrum::Client::DEFAULT_URL)
  end

  it 'gets the key' do
    email = "user@example.com"
    password = "password"

    stub_request(:get, /.*\/users.json/)
      .to_return(status: 200)
  end
end
