require 'spec_helper'

describe Fulcrum::Client do
  let(:client) { Fulcrum::Client.new }

  it 'has a default url' do
    expect(client.url).to eq(Fulcrum::Client::DEFAULT_URL)
  end

  it 'can query' do
    url = "#{client.url}/query"
    response = 'audio,system,,,,,'

    stub_request(:post, url)
      .with(body: '{"q":"select name from tables limit 1;","format":"csv"}')
      .to_return(status: 200, body: response,
                 headers: {"Content-Type" => "text/plain"})

    sql = 'select name from tables limit 1;'
    csv = client.query(sql, 'csv')

    expect(csv).to eq(response)
  end

  it 'cat get_user' do
    url = "https://fred%40flinstones.com:secret@api.fulcrumapp.com/api/v2/users.json"
    response = '{"user":{"first_name":"Jason","last_name":"Sanford","email":"jason@fulcrumapp.com","image_small":"https://fulcrumapp-dev.s3.amazonaws.com/user-images/small_abc.jpg","image_large":"https://fulcrumapp-dev.s3.amazonaws.com/user-images/large_abc.jpg","id":"49d06ce5-1457-476c-9cb4-fd9d41ea43ef","contexts":[{"name":"Team Jason","id":"e09c1a03-819d-47d6-aebc-f8712d292b57","api_token":"abc123","image_small":"https://fulcrumapp-dev.s3.amazonaws.com/organization-images/small_abc.jpg","image_large":"https://fulcrumapp-dev.s3.amazonaws.com/organization-images/large_abc.jpg","type":"organization","role":{},"domain":null,"plan":{}}],"access":{"allowed":true}}}'

    stub_request(:get, url)
      .to_return(status: 200, body: response,
                 headers: {"Content-Type" => "application/json"})

    sql = 'select name from tables limit 1;'
    user = Fulcrum::Client.get_user('fred@flinstones.com', 'secret')

    expect(user['contexts'].length).to eq(1)
    expect(user['contexts'][0]['id']).to eq('e09c1a03-819d-47d6-aebc-f8712d292b57')
  end
end
