require 'spec_helper'

describe Fulcrum::Photo do
  
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe 'successful requests' do
    context '#retrieve' do
      it 'should retrieve the specified photo' do
        photo_id = 'abc'
        stub_request(:get, "#{@uri}/photos/#{photo_id}.jpg").to_return(:status => 200)
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        photo.retrieve('abc', format: 'jpg')
        photo.response.status.should eq(200)
      end
    end
  
    context '#create' do
      it 'should create a new photo and return status 201' do
        stub_request(:post, "#{@uri}/photos").to_return(:status => 201)
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        pic = File.join(File.dirname(__FILE__), '..', 'data', 'test.jpg')
        photo.create(pic, "image/jpeg", "abc123")
        photo.response.status.should eq(201)
      end
    end
  
    context '#thumbnail' do
      it 'should retrieve the photo thumbnail and return status 200' do
        photo_id = 'abc'
        stub_request(:get, "#{@uri}/photos/#{photo_id}/thumbnail.jpg").to_return(:status => 200)
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        r = photo.thumbnail(photo_id)
        photo.response.status.should eq(200)
      end
    end
  
    context '#delete' do
      it 'should delete the photo and return status 200' do
        photo_id = 'abc'
        stub_request(:delete, "#{@uri}/photos/#{photo_id}.json").to_return(:status => 200, :body => '{"photo":{}}')
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        r = photo.delete(photo_id)
        photo.response.status.should eq(200)
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
        stub_request(:get, "#{@uri}/photos/#{photo_id}.jpg").to_return(:status => 404)
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        expect { photo.retrieve(photo_id, format: 'jpg') }.to raise_error(/404/)
      end
    end
    
    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{@uri}/photos").to_return(:status => 422)
        pic = File.join(File.dirname(__FILE__), '..', 'data', 'test.jpg')
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        expect { photo.create(pic, 'image/jpeg', 'abc') }.to raise_error(/422/)
      end
    end
    
    context '#thumbnail' do
      it 'should receive a 422 response' do
        photo_id = 'abc'
        stub_request(:get, "#{@uri}/photos/#{photo_id}/thumbnail.jpg").to_return(:status => 422)
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        expect { photo.thumbnail(photo_id) }.to raise_error(/422/)
      end
    end
    
    context '#delete' do
      it 'should receive a 404 response' do
        photo_id = 'abc'
        stub_request(:delete, "#{@uri}/photos/#{photo_id}.json").to_return(:status => 404)
        photo = Fulcrum::Photo.new(uri: @uri, key: @key)
        expect { photo.delete(photo_id) }.to raise_error(/404/)
      end
    end
  end
end
