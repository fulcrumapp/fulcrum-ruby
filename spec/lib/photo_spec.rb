require 'spec_helper'

describe Fulcrum::Photo do

  before(:all) do
    Fulcrum::Api.configure do |config|
      config.uri = 'http://foo.bar/api/v2'
      config.key = 'foobar'
    end
  end

  describe 'successful requests' do
    context '#retrieve' do
      it 'should retrieve the specified photo' do
        photo_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/photos/#{photo_id}.jpg").to_return(:status => 200)
        Fulcrum::Photo.find('abc', format: 'jpg')
        Fulcrum::Photo.response.status.should eq(200)
      end
    end

    context '#create' do
      it 'should create a new photo and return status 201' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/photos.json").to_return(:status => 201)
        pic = File.join(File.dirname(__FILE__), '..', 'data', 'test.jpg')
        Fulcrum::Photo.create(pic, 'image/*', 'abc', '')
        Fulcrum::Photo.response.status.should eq(201)
      end
    end

    context '#thumbnail' do
      it 'should retrieve the photo thumbnail and return status 200' do
        photo_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/photos/#{photo_id}/thumbnail.jpg").to_return(:status => 200)
        r = Fulcrum::Photo.thumbnail(photo_id, format: 'jpg')
        Fulcrum::Photo.response.status.should eq(200)
      end
    end

    context '#delete' do
      it 'should delete the photo and return status 200' do
        photo_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/photos/#{photo_id}.json").to_return(:status => 204, :body => '{"photo":{}}')
        r = Fulcrum::Photo.delete(photo_id)
        Fulcrum::Photo.response.status.should eq(204)
        r = JSON.parse(r)
        r.keys.should include('photo')
        r['photo'].should be_a(Hash)
      end
    end
  end

  describe 'unsuccessful requests' do
    context '#retrieve' do
      it 'should receive 404' do
        photo_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/photos/#{photo_id}.jpg").to_return(:status => 404)
        p = Fulcrum::Photo.find(photo_id, format: 'jpg')
        p.keys.should include(:error)
        p[:error][:status].should eq(404)
      end
    end

    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/photos.json").to_return(:status => 422)
        pic = File.join(File.dirname(__FILE__), '..', 'data', 'test.jpg')
        p = Fulcrum::Photo.create(pic, 'image/*', 'abc', '')
        p.keys.should include(:error)
        p[:error][:status].should eq(422)
      end
    end

    context '#thumbnail' do
      it 'should receive a 422 response' do
        photo_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/photos/#{photo_id}/thumbnail.jpg").to_return(:status => 404)
        p = Fulcrum::Photo.thumbnail(photo_id, format: 'jpg')
        p.keys.should include(:error)
        p[:error][:status].should eq(404)
      end
    end

    context '#delete' do
      it 'should receive a 404 response' do
        photo_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/photos/#{photo_id}.json").to_return(:status => 404)
        p = Fulcrum::Photo.delete(photo_id)
        p.keys.should include(:error)
        p[:error][:status].should eq(404)
      end
    end
  end
end
