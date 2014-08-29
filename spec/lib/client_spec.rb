require 'spec_helper'

describe Fulcrum::Client do
  let(:client) { Fulcrum::Client.new }

  it 'has a default url' do
    client.url.should eq(Fulcrum::Client::DEFAULT_URL)
  end
end
