require 'spec_helper'

describe Fulcrum::Record do
  
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe '#all' do
    it 'should retrieve all records' do
      stub_request(:get, "#{@uri}/records.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"records":[]}')
      record = Fulcrum::Record.new(uri: @uri, key: @key)
      records = record.all
      records.should be_a(String)
      records = JSON.parse(records)
      records.keys.should include('current_page')
      records.keys.should include('total_pages')
      records.keys.should include('total_count')
      records.keys.should include('per_page')
      records.keys.should include('records')
      records['records'].should be_a(Array)
    end
  end
  
  describe '#retrieve' do
    it 'should retrieve the specified record' do
      record_id = 'abc'
      stub_request(:get, "#{@uri}/records/#{record_id}.json").to_return(:status => 200, :body => '{"record":{}}')
      record = Fulcrum::Record.new(uri: @uri, key: @key)
      r = record.retrieve('abc')
      r.should be_a(String)
      r = JSON.parse(r)
      r.keys.should include('record')
    end
  end
  
  describe '#create' do
  end
  
  describe '#update' do
  end
  
  describe '#delete' do
  end
end
