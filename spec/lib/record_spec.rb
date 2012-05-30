require 'spec_helper'

describe Fulcrum::Record do
  
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all records' do
        stub_request(:get, "#{@uri}/records.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"records":[]}')
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        records = record.all
        record.response.status.should eq(200)
        records = JSON.parse(records)
        records.keys.should include('current_page')
        records.keys.should include('total_pages')
        records.keys.should include('total_count')
        records.keys.should include('per_page')
        records.keys.should include('records')
        records['records'].should be_a(Array)
      end
    end
  
    context '#retrieve' do
      it 'should retrieve the specified record' do
        record_id = 'abc'
        stub_request(:get, "#{@uri}/records/#{record_id}.json").to_return(:status => 200, :body => '{"record":{}}')
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        r = record.retrieve('abc')
        record.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end
  
    context '#create' do
      it 'should create a new record and return status 201' do
        stub_request(:post, "#{@uri}/records.json").to_return(:status => 201, :body => '{"record":{}}')
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        r = record.create({})
        record.response.status.should eq(201)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end
  
    context '#update' do
      it 'should update the record and return status 200' do
        record_id = 'abc'
        stub_request(:put, "#{@uri}/records/#{record_id}.json").to_return(:status => 200, :body => '{"record":{}}')
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        r = record.update(record_id, {})
        record.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end
  
    context '#delete' do
      it 'should delete the record and return status 200' do
        record_id = 'abc'
        stub_request(:delete, "#{@uri}/records/#{record_id}.json").to_return(:status => 200, :body => '{"record":{}}')
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        r = record.delete(record_id)
        record.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end
  end
  
  describe 'unsuccessful requests' do
    context '#retrieve' do
      it 'should receive 404' do
        record_id = 'abc'
        stub_request(:get, "#{@uri}/records/#{record_id}.json").to_return(:status => 404)
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        expect { record.retrieve(record_id) }.to raise_error(/404/)
      end
    end
    
    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{@uri}/records.json").to_return(:status => 422)
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        expect { record.create({}) }.to raise_error(/422/)
      end
    end
    
    context '#update' do
      it 'should receive a 422 response' do
        record_id = 'abc'
        stub_request(:put, "#{@uri}/records/#{record_id}.json").to_return(:status => 422)
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        expect { record.update(record_id, {}) }.to raise_error(/422/)
      end
    end
    
    context '#delete' do
      it 'should receive a 404 response' do
        record_id = 'abc'
        stub_request(:delete, "#{@uri}/records/#{record_id}.json").to_return(:status => 404)
        record = Fulcrum::Record.new(uri: @uri, key: @key)
        expect { record.delete(record_id) }.to raise_error(/404/)
      end
    end
  end
end
