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

    context '#retrieve' do
      it 'should retrieve the specified project' do
        project_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/projects/#{project_id}.json").to_return(:status => 200, :body => '{"project":{}}')
        r = Fulcrum::Project.retrieve('abc')
        Fulcrum::Project.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end

    context '#create' do
      it 'should create a new project and return status 201' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/projects.json").to_return(:status => 201, :body => '{"project":{}}')
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        r = Fulcrum::Project.create({})
        Fulcrum::Project.response.status.should eq(201)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end

    context '#update' do
      it 'should update the project and return status 200' do
        project_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/projects/#{project_id}.json").to_return(:status => 200, :body => '{"project":{}}')
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        r = Fulcrum::Project.update(project_id, {})
        Fulcrum::Project.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end

    context '#delete' do
      it 'should delete the project and return status 200' do
        project_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/projects/#{project_id}.json").to_return(:status => 200, :body => '{"project":{}}')
        r = Fulcrum::Project.delete(project_id)
        Fulcrum::Project.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end
  end

  describe 'unsuccessful requests' do
    context '#retrieve' do
      it 'should receive 404' do
        project_id = 'abc'
        stub_request(:get, "#{Fulcrum::Api.configuration.uri}/projects/#{project_id}.json").to_return(:status => 404)
        expect { Fulcrum::Project.retrieve(project_id) }.to raise_error(/404/)
      end
    end

    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{Fulcrum::Api.configuration.uri}/projects.json").to_return(:status => 422)
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        expect { Fulcrum::Project.create({}) }.to raise_error(/422/)
      end
    end

    context '#update' do
      it 'should receive a 422 response' do
        project_id = 'abc'
        stub_request(:put, "#{Fulcrum::Api.configuration.uri}/projects/#{project_id}.json").to_return(:status => 422)
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        expect { Fulcrum::Project.update(project_id, {}) }.to raise_error(/422/)
      end
    end

    context '#delete' do
      it 'should receive a 404 response' do
        project_id = 'abc'
        stub_request(:delete, "#{Fulcrum::Api.configuration.uri}/projects/#{project_id}.json").to_return(:status => 404)
        expect { Fulcrum::Project.delete(project_id) }.to raise_error(/404/)
      end
    end
  end
end
