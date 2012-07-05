require 'spec_helper'

describe Fulcrum::ClassificationSet do
  before(:all) do
    Fulcrum::Api.configure do |config|
      config.uri = 'http://foo.bar/api/v2'
      config.key = 'foobar'
    end
  end

  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all classification_sets' do
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/classification_sets.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"classification_sets":[]}')
        css = Fulcrum::ClassificationSet.all
        Fulcrum::ClassificationSet.response.status.should eq(200)
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
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/classification_sets/#{cs_id}.json").to_return(:status => 200, :body => '{"classification_set":{}}')
        c = Fulcrum::ClassificationSet.retrieve(cs_id)
        Fulcrum::ClassificationSet.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end

    context '#create' do
      it 'should return created classification_set with status 201' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/classification_sets.json").to_return(:status => 201, :body => '{"classification_set":{}}')
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        c = Fulcrum::ClassificationSet.create({})
        Fulcrum::ClassificationSet.response.status.should eq(201)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end

    context '#update' do
      it 'should return updated classification_set with status 200' do
        cs_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/classification_sets/#{cs_id}.json").to_return(:status => 200, :body => '{"classification_set":{}}')
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        c = Fulcrum::ClassificationSet.update(cs_id, {})
        Fulcrum::ClassificationSet.response.status.should eq(200)
        c = JSON.parse(c)
        c.keys.should include('classification_set')
        c['classification_set'].should be_a(Hash)
      end
    end

    context '#delete' do
      it 'should return deleted classification_set with status 200' do
        cs_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/classification_sets/#{cs_id}.json").to_return(:status => 200, :body => '{"classification_set":{}}')
        c = Fulcrum::ClassificationSet.delete(cs_id)
        Fulcrum::ClassificationSet.response.status.should eq(200)
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
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/classification_sets/#{cs_id}.json").to_return(:status => 404)
        expect { Fulcrum::ClassificationSet.retrieve(cs_id) }.to raise_error(/404/)
      end
    end

    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/classification_sets.json").to_return(:status => 422)
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        expect { Fulcrum::ClassificationSet.create({}) }.to raise_error(/422/)
      end
    end

    context '#update' do
      it 'should receive a 422 response' do
        cs_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/classification_sets/#{cs_id}.json").to_return(:status => 422)
        Fulcrum::ClassificationSetValidator.any_instance.stub(:validate!).and_return(true)
        expect { Fulcrum::ClassificationSet.update(cs_id, {}) }.to raise_error(/422/)
      end
    end

    context '#delete' do
      it 'should receive a 404 response' do
        cs_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/classification_sets/#{cs_id}.json").to_return(:status => 404)
        expect { Fulcrum::ClassificationSet.delete(cs_id) }.to raise_error(/404/)
      end
    end
  end
end
