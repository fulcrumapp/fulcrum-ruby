require 'spec_helper'

describe Fulcrum::Project do
  before(:all) do
    @uri = 'http://foo.bar/api/v2'
    @key = 'foobar'
  end
  
  describe 'successful requests' do
    context '#all' do
      it 'should retrieve all projects' do
        stub_request(:get, "#{@uri}/projects.json").to_return(:status => 200, :body => '{"current_page":1,"total_pages":1,"total_count":1,"per_page":50,"projects":[]}')
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        projects = project.all
        project.response.status.should eq(200)
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
        stub_request(:get, "#{@uri}/projects/#{project_id}.json").to_return(:status => 200, :body => '{"project":{}}')
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        r = project.retrieve('abc')
        project.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end
  
    context '#create' do
      it 'should create a new project and return status 201' do
        stub_request(:post, "#{@uri}/projects.json").to_return(:status => 201, :body => '{"project":{}}')
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        r = project.create({})
        project.response.status.should eq(201)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end
  
    context '#update' do
      it 'should update the project and return status 200' do
        project_id = 'abc'
        stub_request(:put, "#{@uri}/projects/#{project_id}.json").to_return(:status => 200, :body => '{"project":{}}')
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        r = project.update(project_id, {})
        project.response.status.should eq(200)
        r = JSON.parse(r)
        r.keys.should include('project')
        r['project'].should be_a(Hash)
      end
    end
  
    context '#delete' do
      it 'should delete the project and return status 200' do
        project_id = 'abc'
        stub_request(:delete, "#{@uri}/projects/#{project_id}.json").to_return(:status => 200, :body => '{"project":{}}')
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        r = project.delete(project_id)
        project.response.status.should eq(200)
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
        stub_request(:get, "#{@uri}/projects/#{project_id}.json").to_return(:status => 404)
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        expect { project.retrieve(project_id) }.to raise_error(/404/)
      end
    end
    
    context '#create' do
      it 'should receive a 422 response' do
        stub_request(:post, "#{@uri}/projects.json").to_return(:status => 422)
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        expect { project.create({}) }.to raise_error(/422/)
      end
    end
    
    context '#update' do
      it 'should receive a 422 response' do
        project_id = 'abc'
        stub_request(:put, "#{@uri}/projects/#{project_id}.json").to_return(:status => 422)
        Fulcrum::ProjectValidator.any_instance.stub(:validate!).and_return(true)
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        expect { project.update(project_id, {}) }.to raise_error(/422/)
      end
    end
    
    context '#delete' do
      it 'should receive a 404 response' do
        project_id = 'abc'
        stub_request(:delete, "#{@uri}/projects/#{project_id}.json").to_return(:status => 404)
        project = Fulcrum::Project.new(uri: @uri, key: @key)
        expect { project.delete(project_id) }.to raise_error(/404/)
      end
    end
  end
end