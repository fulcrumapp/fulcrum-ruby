require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Form do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.forms }

  include_examples 'lists resource'
  include_examples 'finds resource'
  include_examples 'creates resource'
  include_examples 'updates resource'
  include_examples 'deletes resource'

  it 'lists all resources' do
    url = "#{client.url}/forms/8ae9115-0430-459e-a1b7-7ac46011e0ce/history.json"

    stub_request(:get, url)
      .to_return(status: 200, body: list_response,
                 headers: {"Content-Type" => "application/json"})

    page = resource.history('8ae9115-0430-459e-a1b7-7ac46011e0ce')

    expect(client.response.status).to eq(200)

    expect(page).to respond_to(:current_page)
    expect(page).to respond_to(:total_pages)
    expect(page).to respond_to(:total_count)
    expect(page).to respond_to(:per_page)

    expect(page.objects).to be_a(Array)
  end

end
