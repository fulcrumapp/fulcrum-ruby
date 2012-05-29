require 'spec_helper'

describe Fulcrum::RecordValidator do
  describe '#validates!' do
    it 'should not be valid without a record hash' do
      data = {}
      validator = Fulcrum::RecordValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid if record is not a hash' do
      data = { 'record' => nil }
      validator = Fulcrum::RecordValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid without a form_id' do
      data = { 'record' => { 'form_id' => '' } }
      validator = Fulcrum::RecordValidator.new(data)
      validator.should_not be_valid
      validator.errors['record']['form_id'].should_not be_blank
    end
    
    it 'should not be valid if form_values is not a hash' do
      data = { 'record' => { 'form_id' => 'foobar', 'form_values' => nil } }
      validator = Fulcrum::RecordValidator.new(data)
      validator.should_not be_valid
      validator.errors['record']['form_values'].should_not be_blank
    end

    it 'should not be valid if form_values is empty' do
      data = { 'record' => { 'form_id' => 'foobar', 'form_values' => {} } }
      validator = Fulcrum::RecordValidator.new(data)
      validator.should_not be_valid
      validator.errors['record']['form_values'].should_not be_blank
    end
    
    it 'should not be valid with invalid coordinates' do
      data = { 'record' => { 'form_id' => 'foobar', 'form_values' => { 'foo' => 'bar'}, 'latitude' => '0', 'longitude' => '0' } }
      validator = Fulcrum::RecordValidator.new(data)
      validator.should_not be_valid
      validator.errors['record']['coordinates'].should_not be_blank
    end
    
    it 'should be valid' do
      data = { 'record' => { 'form_id' => 'foobar', 'form_values' => { 'foo' => 'bar'}, 'latitude' => '1.0', 'longitude' => '1.0' } }
      validator = Fulcrum::RecordValidator.new(data)
      validator.should be_valid
      validator.errors.should be_empty
    end
  end
end
  