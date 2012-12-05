require 'spec_helper'

describe Fulcrum::Project do

  before(:all) do
    Fulcrum::Api.configure do |config|
      config.uri = 'http://foo.bar/api/v2'
      config.key = 'foobar'
    end
  end

  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all projects' do
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/projects.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"projects":[]}')
        projects = Fulcrum::Project.all
        Fulcrum::Project.response.status.should eq(200)
        projects = JSON.parse(projects)
        projects.keys.should include('current_page')
        projects.keys.should include('total_pages')
        projects.keys.should include('total_count')
        projects.keys.should include('per_page')
        projects.keys.should include('projects')
        projects['projects'].should be_a(Array)
      end
    end
  end

end
