require 'spec_helper'

describe Fulcrum::Form do
  
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe '#all' do
    it 'should retrieve all records' do
      stub_request(:get, "#{@uri}/forms.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"forms":[]}')
      form = Fulcrum::Form.new(uri: @uri, key: @key)
      forms = form.all
      forms.should be_a(String)
      forms = JSON.parse(forms)
      forms.keys.should include('current_page')
      forms.keys.should include('total_pages')
      forms.keys.should include('total_count')
      forms.keys.should include('per_page')
      forms.keys.should include('forms')
      forms['forms'].should be_a(Array)
    end
  end
  
  describe '#retrieve' do
    it 'should retrieve the specified record' do
      form_id = "abc"
      stub_request(:get, "#{@uri}/forms/#{form_id}.json").to_return(:status => 200, :body => '{"form":{}}')
      form = Fulcrum::Form.new(uri: @uri, key: @key)
      f = form.retrieve(form_id)
      f.should be_a(String)
      f = JSON.parse(f)
      f.keys.should include('form')
    end
  end
  
  describe '#create' do
  end
  
  describe '#update' do
  end
  
  describe '#delete' do
  end
end
