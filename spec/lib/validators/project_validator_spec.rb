require 'spec_helper'

describe Fulcrum::ProjectValidator do
  describe '#validates!' do
    it 'should not be valid without a project hash' do
      data = {}
      validator = Fulcrum::ProjectValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid if project is not a hash' do
      data = { 'project' => nil }
      validator = Fulcrum::ProjectValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid without a title' do
      data = { 'project' => { 'title' => '' } }
      validator = Fulcrum::ProjectValidator.new(data)
      validator.should_not be_valid
      validator.errors['project']['title'].should_not be_blank
    end
    
    it 'should not be valid if member_ids is empty' do
      data = { 'project' => { 'title' => 'foo', 'member_ids' => [] } }
      validator = Fulcrum::ProjectValidator.new(data)
      validator.should_not be_valid
      validator.errors['project']['member_ids'].should_not be_blank
    end

    it 'should not be valid if form_ids is empty' do
      data = { 'project' => { 'title' => 'foo', 'form_ids' => [] } }
      validator = Fulcrum::ProjectValidator.new(data)
      validator.should_not be_valid
      validator.errors['project']['form_ids'].should_not be_blank
    end
  end
end
