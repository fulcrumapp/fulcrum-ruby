require 'spec_helper'

describe Fulcrum::Form do

  before(:all) do
    Fulcrum::Api.configure do |config|
      config.uri = 'http://foo.bar/api/v2'
      config.key = 'foobar'
    end
  end

  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all records' do
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/forms.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"forms":[]}')
        forms = Fulcrum::Form.all
        Fulcrum::Form.response.status.should eq(200)
        forms = JSON.parse(forms)
        forms.keys.should include('current_page')
        forms.keys.should include('total_pages')
        forms.keys.should include('total_count')
        forms.keys.should include('per_page')
        forms.keys.should include('forms')
        forms['forms'].should be_a(Array)
      end
    end

    context '#retrieve' do
      it 'should retrieve the specified record and return 200' do
        form_id = "abc"
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
        f = Fulcrum::Form.find(form_id)
        Fulcrum::Form.response.status.should eq(200)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end

    context '#create' do
      it 'should return created form with status 201' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/forms.json").to_return(:status => 201, :body => '{"form":{}}')
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        f = Fulcrum::Form.create({})
        Fulcrum::Form.response.status.should eq(201)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end

    context '#update' do
      it 'should return updated form with status 200' do
        form_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        f = Fulcrum::Form.update(form_id, {})
        Fulcrum::Form.response.status.should eq(200)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end

    context '#delete' do
      it 'should return deleted form with status 200' do
        form_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
        f = Fulcrum::Form.delete(form_id)
        Fulcrum::Form.response.status.should eq(200)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end
  end

  describe 'unsuccessful requests' do
    context '#retrieve' do
      it 'should receive 404' do
        form_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 404)
        expect { Fulcrum::Form.find(form_id) }.to raise_error(/404/)
      end
    end

    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/forms.json").to_return(:status => 422)
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        expect { Fulcrum::Form.create({}) }.to raise_error(/422/)
      end
    end

    context '#update' do
      it 'should receive a 422 response' do
        form_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 422)
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        expect { Fulcrum::Form.update(form_id, {}) }.to raise_error(/422/)
      end
    end

    context '#delete' do
      it 'should receive a 404 response' do
        form_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 404)
        expect { Fulcrum::Form.delete(form_id) }.to raise_error(/404/)
      end
    end
  end
end
