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
      let(:create_parameters) { [ File.open(test_file), resource_object[:id] ] }
    end

    shared_examples "a resource" do
      include_context "with client"

      describe "successful requests" do
        let(:pagination) do
          { current_page: 1,
            total_pages: 1,
            total_count: 1,
            per_page: 50 }
        end

        let(:index_response) do
          data = pagination
          data[resource.resources_name.to_sym] = []
          data.as_json
        end

        let(:show_response) do
          data = {}
          data[resource_name] = resource_object
          data.as_json
        end

        let(:resource_id) do
          'abc'
        end

        let(:collection_url) do
          "#{client.url}/#{resource.collection}?per_page=#{Fulcrum::Resource::DEFAULT_PER_PAGE}"
        end

        let(:create_url) do
          "#{client.url}/#{resource.create_action}"
        end

        let(:member_url) do
          "#{client.url}/#{resource.member(resource_id)}"
        end

        let(:resource_name) do
          resource.resource_name
        end

        let(:resources_name) do
          resource.resources_name
        end

        it 'should retrieve all objects' do
          stub_request(:get, collection_url)
            .to_return(status: 200, body: index_response)

          page = resource.all

          client.response.status.should eq(200)

          page.should respond_to(:current_page)
          page.should respond_to(:total_pages)
          page.should respond_to(:total_count)
          page.should respond_to(:per_page)

          page.objects.should be_a(Array)
        end

        it 'should retrieve the specified object and return 200' do
          stub_request(:get, member_url)
            .to_return(status: 200, body: show_response)

          object = resource.find(resource_id)

          client.response.status.should eq(200)

          object.should be_a(Hash)
        end

        it 'should create the object with status 201' do
          stub_request(:post, create_url)
            .to_return(status: 201, body: show_response)

          object = resource.create(*create_parameters)

          client.response.status.should eq(201)

          object.should be_a(Hash)
        end

        it 'should update the object with status 200' do
          stub_request(:put, member_url)
            .to_return(status: 200, body: show_response)

          object = resource.update(resource_id, resource_object)

          client.response.status.should eq(200)

          object.should be_a(Hash)
        end

        it 'should delete the object with status 200' do
          stub_request(:delete, member_url)
            .to_return(status: 204, body: show_response)

          object = resource.delete(resource_id)

          client.response.status.should eq(204)

          object.should be_a(Hash)
        end

      end
    end
  end
end
