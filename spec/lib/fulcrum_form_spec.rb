require 'spec_helper'
describe Fulcrum::Form do
  
  before(:all) do
    @uri = 'http://example.com/api/v2'
    @key = 'abc'
    stub_request(:any, /http:\/\/.*\/api\/v2\/.*\.json/)
  end
  
  describe '#all' do
    it 'should retrieve all records' do
      form = Fulcrum::Form.new(uri: @uri, key: @key)
    end
  end
end