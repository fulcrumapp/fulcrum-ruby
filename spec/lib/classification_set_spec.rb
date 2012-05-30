require 'spec_helper'

describe Fulcrum::ClassificationSet do
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all classification_sets' do
        stub_request(:get, "#{@uri}/classification_sets.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"classification_sets":[]}')
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        css = cs.all
        cs.response.status.should eq(200)
        css = JSON.parse(css)
        css.keys.should include('current_page')
        css.keys.should include('total_pages')
        css.keys.should include('total_count')
        css.keys.should include('per_page')
        css.keys.should include('classification_sets')
        css['classification_sets'].should be_a(Array)
      end
    end
    
    context '#retrieve' do
      it 'should retrieve the specified classification_set and return 200' do
        cs_id = "abc"
        stub_request(:get, "#{@uri}/classification_sets/#{cs_id}.json").to_return(:status => 200, :body => '{"classification_set":{}}')
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        c = cs.retrieve(cs_id)
        cs.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end
  
    context '#create' do
      it 'should return created classification_set with status 201' do
        stub_request(:post, "#{@uri}/classification_sets.json").to_return(:status => 201, :body => '{"classification_set":{}}')
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        c = cs.create({})
        cs.response.status.should eq(201)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end
  
    context '#update' do
      it 'should return updated classification_set with status 200' do
        cs_id = 'abc'
        stub_request(:put, "#{@uri}/classification_sets/#{cs_id}.json").to_return(:status => 200, :body => '{"classification_set":{}}')
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        c = cs.update(cs_id, {})
        cs.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end
  
    context '#delete' do
      it 'should return deleted classification_set with status 200' do
        cs_id = 'abc'
        stub_request(:delete, "#{@uri}/classification_sets/#{cs_id}.json").to_return(:status => 200, :body => '{"classification_set":{}}')
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        c = cs.delete(cs_id)
        cs.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end
  end
  
  describe 'unsuccessful requests' do
    context '#retrieve' do
      it 'should receive 404' do
        cs_id = 'abc'
        stub_request(:get, "#{@uri}/classification_sets/#{cs_id}.json").to_return(:status => 404)
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        expect { cs.retrieve(cs_id) }.to raise_error(/404/)
      end
    end
    
    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{@uri}/classification_sets.json").to_return(:status => 422)
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        expect { cs.create({}) }.to raise_error(/422/)
      end
    end
    
    context '#update' do
      it 'should receive a 422 response' do
        cs_id = 'abc'
        stub_request(:put, "#{@uri}/classification_sets/#{cs_id}.json").to_return(:status => 422)
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        expect { cs.update(cs_id, {}) }.to raise_error(/422/)
      end
    end
    
    context '#delete' do
      it 'should receive a 404 response' do
        cs_id = 'abc'
        stub_request(:delete, "#{@uri}/classification_sets/#{cs_id}.json").to_return(:status => 404)
        cs = Fulcrum::ClassificationSet.new(uri: @uri, key: @key)
        expect { cs.delete(cs_id) }.to raise_error(/404/)
      end
    end
  end
end
