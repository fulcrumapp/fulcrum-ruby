require 'spec_helper'

describe Fulcrum::Form do
  
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all records' do
        stub_request(:get, "#{@uri}/forms.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"forms":[]}')
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        forms = form.all
        form.response.status.should eq(200)
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
        stub_request(:get, "#{@uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        f = form.retrieve(form_id)
        form.response.status.should eq(200)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end
  
    context '#create' do
      it 'should return created form with status 201' do
        stub_request(:post, "#{@uri}/forms.json").to_return(:status => 201, :body => '{"form":{}}')
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        f = form.create({})
        form.response.status.should eq(201)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end
  
    context '#update' do
      it 'should return updated form with status 200' do
        form_id = 'abc'
        stub_request(:put, "#{@uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        f = form.update(form_id, {})
        form.response.status.should eq(200)
        f = JSON.parse(f)
        f.keys.should include('form')
        f['form'].should be_a(Hash)
      end
    end
  
    context '#delete' do
      it 'should return deleted form with status 200' do
        form_id = 'abc'
        stub_request(:delete, "#{@uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        f = form.delete(form_id)
        form.response.status.should eq(200)
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
        stub_request(:get, "#{@uri}/forms/#{form_id}.json").to_return(:status => 404)
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        expect { form.retrieve(form_id) }.to raise_error(/404/)
      end
    end
    
    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{@uri}/forms.json").to_return(:status => 422)
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        expect { form.create({}) }.to raise_error(/422/)
      end
    end
    
    context '#update' do
      it 'should receive a 422 response' do
        form_id = 'abc'
        stub_request(:put, "#{@uri}/forms/#{form_id}.json").to_return(:status => 422)
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        expect { form.update(form_id, {}) }.to raise_error(/422/)
      end
    end
    
    context '#delete' do
      it 'should receive a 404 response' do
        form_id = 'abc'
        stub_request(:delete, "#{@uri}/forms/#{form_id}.json").to_return(:status => 404)
        form = Fulcrum::Form.new(uri: @uri, key: @key)
        expect { form.delete(form_id) }.to raise_error(/404/)
      end
    end
  end
end
