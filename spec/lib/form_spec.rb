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
        records = {"current_page" => 1,"total_pages" => 1,"total_count" => 1,"per_page" => 50,"forms" => []}
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/forms.json").to_return(:status => 200, :body => records.to_json)
        forms = Fulcrum::Form.all
        Fulcrum::Form.response.status.should eq(200)
        forms = JSON.parse(forms)
        forms.should == records
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
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 204, :body => '{"form":{}}')
        f = Fulcrum::Form.delete(form_id)
        Fulcrum::Form.response.status.should eq(204)
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
        c = Fulcrum::Form.find(form_id)
        c.keys.should include(:error)
        c[:error][:status].should eq(404)
      end
    end

    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/forms.json").to_return(:status => 422)
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        c = Fulcrum::Form.create({})
        c.keys.should include(:error)
        c[:error][:status].should eq(422)
      end
    end

    context '#update' do
      it 'should receive a 422 response' do
        form_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 422)
        Fulcrum::FormValidator.any_instance.stub(:validate!).and_return(true)
        c = Fulcrum::Form.update(form_id, {})
        c.keys.should include(:error)
        c[:error][:status].should eq(422)
      end
    end

    context '#delete' do
      it 'should receive a 404 response' do
        form_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/forms/#{form_id}.json").to_return(:status => 404, :body => { :message => "error message"})
        c = Fulcrum::Form.delete(form_id)
        c.keys.should include(:error)
        c[:error][:status].should eq(404)
        c[:error][:message].should eq({ :message => "error message" })
      end
    end
  end
end
