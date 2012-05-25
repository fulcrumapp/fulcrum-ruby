require 'spec_helper'
describe Fulcrum::Form do
  
  before(:all) do
    @uri = 'http://example.com/api/v2'
    @key = 'abc'
  end
  
  describe '#all' do
    it 'should retrieve all records' do
      stub_request(:any, /.*\/api\/v2\/forms\.json/)
      form = Fulcrum::Form.new(uri: @uri, key: @key)
      body = form.all
    end
  end
end