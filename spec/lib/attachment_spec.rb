require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Attachment do
  let(:test_file) { './spec/data/test.pdf' }

  include_context 'with client'
  include_context 'with media resource'
  include_context 'with resource parameters'

  let(:resource) { client.attachments }

  include_examples 'finds resource'
  include_examples 'deletes resource'

  let(:create_url) do
    "#{client.url}/#{resource.create_action}"
  end

  describe '#all' do
    let(:list_response) do
      data = {}
      data["form_id"] = {}
      data.to_json
    end

    it 'lists all attachments' do
      stub_request(:get, create_url)
        .to_return(status: 200, body: list_response,
                   headers: {"Content-Type" => "application/json"})

      resources = resource.all

      expect(client.response.status).to eq(200)

      expect(resources).to be_a(Hash)
    end
  end

  describe '#create' do
    let(:ws_url) do
      'https://fulcrumapp.s3.amazonaws.com/attachments/example'
    end

    let(:attrs) do
      { "name": "Test",
        "owners": [ {
          "type": "form",
          "id": "12345"
      } ] }
    end

    let(:response) do
      data = {}
      data['url'] = ws_url
      data['id'] = "123"
      data.to_json
    end
    
    let(:create_parameters) { [ File.open(test_file) , attrs ] }

    it 'creates attachment data' do
      stub_request(:post, create_url)
        .with(body: attrs)
          .to_return(status: 200, body: response,
                   headers: {"Content-Type" => "application/json"})
      stub_request(:put, ws_url)
          .to_return(status: 200,
                   headers: {"Content-Type" => "application/json"})

      object = resource.create(*create_parameters)

      expect(client.response.status).to eq(200)

      expect(object[:name]).to eq(attrs[:name])

      expect(object[:attachment_id]).to eq(JSON.parse(response)['id'])
    end
  end

  describe '#finalize' do
    it 'finalizes the attachment' do
      stub_request(:post, "#{create_url}/finalize")
        .to_return(status: 201,
                   headers: {"Content-Type" => "application/json"})

      object = resource.finalize(resource_id)

      expect(client.response.status).to eq(201)
    end
  end
end