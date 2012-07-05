require 'spec_helper'

describe Fulcrum::Project do
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
end
