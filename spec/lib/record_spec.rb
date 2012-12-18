require 'spec_helper'

describe Fulcrum::Record do

  before(:all) do
    Fulcrum::Api.configure do |config|
      config.uri = 'http://foo.bar/api/v2'
      config.key = 'foobar'
    end
  end

  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all records' do
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/records.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"records":[]}')
        records = Fulcrum::Record.all
        Fulcrum::Record.response.status.should eq(200)
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
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/records/#{record_id}.json").to_return(:status => 200, :body => '{"record":{}}')
        r = Fulcrum::Record.find('abc')
        Fulcrum::Record.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end

    context '#create' do
      it 'should create a new record and return status 201' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/records.json").to_return(:status => 201, :body => '{"record":{}}')
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        r = Fulcrum::Record.create({})
        Fulcrum::Record.response.status.should eq(201)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end

    context '#update' do
      it 'should update the record and return status 200' do
        record_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/records/#{record_id}.json").to_return(:status => 200, :body => '{"record":{}}')
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        r = Fulcrum::Record.update(record_id, {})
        Fulcrum::Record.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('record')
        r['record'].should be_a(Hash)
      end
    end

    context '#delete' do
      it 'should delete the record and return status 200' do
        record_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/records/#{record_id}.json").to_return(:status => 204, :body => '{"record":{}}')
        r = Fulcrum::Record.delete(record_id)
        Fulcrum::Record.response.status.should eq(204)
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
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/records/#{record_id}.json").to_return(:status => 404)
        r = Fulcrum::Record.find(record_id)
        r.keys.should include(:error)
        r[:error][:status].should eq(404)
      end
    end

    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/records.json").to_return(:status => 422)
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        r = Fulcrum::Record.create({})
        r.keys.should include(:error)
        r[:error][:status].should eq(422)
      end
    end

    context '#update' do
      it 'should receive a 422 response' do
        record_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/records/#{record_id}.json").to_return(:status => 422)
        Fulcrum::RecordValidator.any_instance.stub(:validate!).and_return(true)
        r = Fulcrum::Record.update(record_id, {})
        r.keys.should include(:error)
        r[:error][:status].should eq(422)
      end
    end

    context '#delete' do
      it 'should receive a 404 response' do
        record_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/records/#{record_id}.json").to_return(:status => 404, :body => { :message => "error message"})
        r = Fulcrum::Record.delete(record_id)
        r.keys.should include(:error)
        r[:error][:status].should eq(404)
        r[:error][:message].should eq({ :message => "error message" })
      end
    end
  end
end
