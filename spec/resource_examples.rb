require 'spec_helper'

include Support::ClientHelper

module Support
  module ResourceExamples
    shared_context 'with resource' do
      let(:resource_object) { {} }
      let(:create_parameters) { [ resource_object ] }
    end

    shared_context 'with media resource' do
      let(:resource_object) { { id: SecureRandom.uuid } }
      let(:create_parameters) { [ File.open(test_file), nil, { access_key: resource_id } ] }
    end

    shared_context 'with resource parameters' do
      let(:resource_id) do
        'abc'
      end

      let(:resource_name) do
        resource.resource_name
      end

      let(:resources_name) do
        resource.resources_name
      end

      let(:collection_url) do
        "#{client.url}/#{resource.collection}?per_page=#{resource.default_list_params[:per_page]}"
      end

      let(:member_url) do
        "#{client.url}/#{resource.member(resource_id)}"
      end

      let(:show_response) do
        data = {}
        data[resource_name] = resource_object
        data.to_json
      end
    end

    shared_examples 'lists resource' do
      include_context 'with client'
      include_context 'with resource parameters'

      let(:pagination) do
        { current_page: 1,
          total_pages: 1,
          total_count: 1,
          per_page: 50 }
      end

      let(:list_response) do
        data = pagination
        data[resource.resources_name.to_sym] = []
        data.to_json
      end

      it 'lists all resources' do
        stub_request(:get, collection_url)
          .to_return(status: 200, body: list_response,
                     headers: {"Content-Type" => "application/json"})

        page = resource.all

        expect(client.response.status).to eq(200)

        expect(page).to respond_to(:current_page)
        expect(page).to respond_to(:total_pages)
        expect(page).to respond_to(:total_count)
        expect(page).to respond_to(:per_page)

        expect(page.objects).to be_a(Array)
      end
    end

    shared_examples 'finds resource' do
      include_context 'with client'
      include_context 'with resource parameters'

      it 'finds a resource' do
        stub_request(:get, member_url)
          .to_return(status: 200, body: show_response,
                     headers: {"Content-Type" => "application/json"})

        object = resource.find(resource_id)

        expect(client.response.status).to eq(200)

        expect(object).to be_a(Hash)
      end
    end

    shared_examples 'creates resource' do
      include_context 'with client'
      include_context 'with resource parameters'

      let(:create_url) do
        "#{client.url}/#{resource.create_action}"
      end

      it 'creates a new resource' do
        stub_request(:post, create_url)
          .to_return(status: 201, body: show_response,
                     headers: {"Content-Type" => "application/json"})

        object = resource.create(*create_parameters)

        expect(client.response.status).to eq(201)

        expect(object).to be_a(Hash)
      end
    end

    shared_examples 'updates resource' do
      include_context 'with client'
      include_context 'with resource parameters'

      it 'updates a resource' do
        stub_request(:put, member_url)
          .to_return(status: 200, body: show_response,
                     headers: {"Content-Type" => "application/json"})

        object = resource.update(resource_id, resource_object)

        expect(client.response.status).to eq(200)

        expect(object).to be_a(Hash)
      end
    end

    shared_examples 'deletes resource' do
      include_context 'with client'
      include_context 'with resource parameters'

      it 'deletes a resource' do
        stub_request(:delete, member_url)
          .to_return(status: 204, body: show_response,
                     headers: {"Content-Type" => "application/json"})

        object = resource.delete(resource_id)

        puts object.inspect

        expect(client.response.status).to eq(204)

        expect(object).to be_a(Hash)
      end
    end
  end
end
