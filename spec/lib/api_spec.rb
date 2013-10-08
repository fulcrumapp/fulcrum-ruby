require 'spec_helper'

describe Fulcrum::Api do
  let(:default_uri) { 'https://api.fulcrumapp.com/api/v2' }

  let(:uri) { 'http://foo.bar/api/v2' }
  let(:key) { 'foobar' }

  it 'has a default uri' do
    Fulcrum::Api.configuration.uri.should eq(default_uri)
  end

  it 'is configured' do
    Fulcrum::Api.configure do |config|
      config.uri = uri
      config.key = key
    end

    Fulcrum::Api.configuration.uri.should eq(uri)
    Fulcrum::Api.configuration.key.should eq(key)
  end

  it 'gets the key' do
    user = "foo@bar.com"
    pass = "foobar"
    stub_request(:get, /.*\/users.json/).to_return(:status => 200, :body => '{ "user": { "api_token": "foobar" }}')
    Fulcrum::Api.get_key(user, pass).should eq('foobar')
  end

  specify '#parse_opts returns only expected opts' do
    params = Fulcrum::Api.parse_opts([:foo], { foo: 'bar', bar: 'foo'})
    params.should eq({ foo: 'bar' })
  end

  specify '#call should raise ArgumentError with invalid method' do
    expect { Fulcrum::Api.call(:foo) }.to raise_error(ArgumentError)
  end

  specify '#call should not raise ArgumentError with valid method' do
    expect { Fulcrum::Api.call(:get) }.to_not raise_error(ArgumentError)
  end
end
