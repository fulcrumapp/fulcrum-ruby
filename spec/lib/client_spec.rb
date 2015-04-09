require 'spec_helper'

describe Fulcrum::Client do
  let(:client) { Fulcrum::Client.new }

  it 'has a default url' do
    expect(client.url).to eq(Fulcrum::Client::DEFAULT_URL)
  end
end
