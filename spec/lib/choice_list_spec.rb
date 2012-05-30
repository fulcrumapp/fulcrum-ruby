require 'spec_helper'

describe Fulcrum::ChoiceList do
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all choice_lists' do
        stub_request(:get, "#{@uri}/choice_lists.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"choice_lists":[]}')
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        cls = cl.all
        cl.response.status.should eq(200)
        cls = JSON.parse(cls)
        cls.keys.should include('current_page')
        cls.keys.should include('total_pages')
        cls.keys.should include('total_count')
        cls.keys.should include('per_page')
        cls.keys.should include('choice_lists')
        cls['choice_lists'].should be_a(Array)
      end
    end
    
    context '#retrieve' do
      it 'should retrieve the specified choice_list and return 200' do
        cl_id = "abc"
        stub_request(:get, "#{@uri}/choice_lists/#{cl_id}.json").to_return(:status => 200, :body => '{"choice_list":{}}')
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        c = cl.retrieve(cl_id)
        cl.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('choice_list')
        c['choice_list'].should be_a(Hash)
      end
    end
  
    context '#create' do
      it 'should return created choice_list with status 201' do
        stub_request(:post, "#{@uri}/choice_lists.json").to_return(:status => 201, :body => '{"choice_list":{}}')
        Fulcrum::ChoiceListValidator.any_instance.stub(:validate!).and_return(true)
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        c = cl.create({})
        cl.response.status.should eq(201)
        c = JSON.parse(c)
        c.keys.should include('choice_list')
        c['choice_list'].should be_a(Hash)
      end
    end
  
    context '#update' do
      it 'should return updated choice_list with status 200' do
        cl_id = 'abc'
        stub_request(:put, "#{@uri}/choice_lists/#{cl_id}.json").to_return(:status => 200, :body => '{"choice_list":{}}')
        Fulcrum::ChoiceListValidator.any_instance.stub(:validate!).and_return(true)
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        c = cl.update(cl_id, {})
        cl.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('choice_list')
        c['choice_list'].should be_a(Hash)
      end
    end
  
    context '#delete' do
      it 'should return deleted choice_list with status 200' do
        cl_id = 'abc'
        stub_request(:delete, "#{@uri}/choice_lists/#{cl_id}.json").to_return(:status => 200, :body => '{"choice_list":{}}')
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        c = cl.delete(cl_id)
        cl.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('choice_list')
        c['choice_list'].should be_a(Hash)
      end
    end
  end
  
  describe 'unsuccessful requests' do
    context '#retrieve' do
      it 'should receive 404' do
        cl_id = 'abc'
        stub_request(:get, "#{@uri}/choice_lists/#{cl_id}.json").to_return(:status => 404)
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        expect { cl.retrieve(cl_id) }.to raise_error(/404/)
      end
    end
    
    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{@uri}/choice_lists.json").to_return(:status => 422)
        Fulcrum::ChoiceListValidator.any_instance.stub(:validate!).and_return(true)
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        expect { cl.create({}) }.to raise_error(/422/)
      end
    end
    
    context '#update' do
      it 'should receive a 422 response' do
        cl_id = 'abc'
        stub_request(:put, "#{@uri}/choice_lists/#{cl_id}.json").to_return(:status => 422)
        Fulcrum::ChoiceListValidator.any_instance.stub(:validate!).and_return(true)
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        expect { cl.update(cl_id, {}) }.to raise_error(/422/)
      end
    end
    
    context '#delete' do
      it 'should receive a 404 response' do
        cl_id = 'abc'
        stub_request(:delete, "#{@uri}/choice_lists/#{cl_id}.json").to_return(:status => 404)
        cl = Fulcrum::ChoiceList.new(uri: @uri, key: @key)
        expect { cl.delete(cl_id) }.to raise_error(/404/)
      end
    end
  end
end
