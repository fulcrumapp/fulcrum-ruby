require 'spec_helper'

describe Fulcrum::Api do
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
    Fulcrum::Api.configure do |config|
      config.uri = 'http://foo.bar/api/v2'
      config.key = 'foobar'
    end
  end

  it 'should be configured' do
    Fulcrum::Api.configuration.uri.should eq(@uri)
    Fulcrum::Api.configuration.key.should eq(@key)
  end

  it 'should get the key' do
    user = "foo@bar.com"
    pass = "foobar"
    stub_request(:get, /.*\/users.json/).to_return(:status => 200, :body => '{ "user": { "api_token": "foobar" }}')
    Fulcrum::Api.get_key(user, pass).should eq('foobar')
  end

  it 'parse_opts should return only expected opts' do
    params = Fulcrum::Api.parse_opts([:foo], { foo: 'bar', bar: 'foo'})
    params.has_key?(:foo).should be(true)
    params[:foo].should eq('bar')
    params.has_key?(:bar).should be(false)
  end

  it 'call should raise ArgumentError with invalid method' do
    expect { Fulcrum::Api.call(:foo) }.to raise_error(ArgumentError)
  end

  it 'call should not raise ArgumentError with valid method' do
    expect { Fulcrum::Api.call(:get) }.to_not raise_error(ArgumentError)
  end
end
