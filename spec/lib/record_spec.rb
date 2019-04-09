require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Record do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.records }

  include_examples 'lists resource'
  include_examples 'finds resource'
  include_examples 'creates resource'
  include_examples 'updates resource'
  include_examples 'deletes resource'

  it 'lists all resources' do
    url = "#{client.url}/records/abc-123/history.json"

    stub_request(:get, url)
      .to_return(status: 200, body: list_response,
                 headers: {"Content-Type" => "application/json"})

    page = resource.history('abc-123')

    expect(client.response.status).to eq(200)

    expect(page).to respond_to(:current_page)
    expect(page).to respond_to(:total_pages)
    expect(page).to respond_to(:total_count)
    expect(page).to respond_to(:per_page)

    expect(page.objects).to be_a(Array)
  end
end
