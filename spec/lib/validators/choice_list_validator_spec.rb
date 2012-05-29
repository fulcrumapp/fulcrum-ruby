require 'spec_helper'

describe Fulcrum::ChoiceListValidator do
  
  describe '#validates!' do
    it 'should not be valid without a choice_list hash' do
      data = {}
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid if choice_list is not a hash' do
      data = { 'choice_list' => nil }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid without an empty choice_list hash' do
      data = { 'choice_list' => {}}
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid without a name' do
      data = { 'choice_list' => { 'name' => '' } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
      validator.errors['choice_list']['name'].should_not be_blank
    end
    
    it 'should not be valid without any choices' do
      data = { 'choice_list' => { 'name' => 'foobar' } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
      validator.errors['choice_list']['choices'].should_not be_blank
    end
    
    it 'should not be valid with a non array choices element' do
      data = { 'choice_list' => { 'name' => 'foobar', 'choices'=> {} } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
      validator.errors['choice_list']['choices'].should_not be_blank
    end

    it 'should not be valid with an empty choices array' do
      data = { 'choice_list' => { 'name' => 'foobar', 'choices'=> [] } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
      validator.errors['choice_list']['choices'].should_not be_blank
    end

    it 'should not be valid with an empty choice' do
      data = { 'choice_list' => { 'name' => 'foobar', 'choices'=> [{}] } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
      validator.errors['choices']['choice'].should_not be_blank
    end
    
    it 'should not be valid with a choice that does not have label' do
      data = { 'choice_list' => { 'name' => 'foobar', 'choices'=> [{ 'foo' => 'bar' }] } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should_not be_valid
      validator.errors['choice']['label'].should_not be_blank
    end
    
    it 'should be valid' do
      data = { 'choice_list' => { 'name' => 'foobar', 'choices'=> [{ 'label' => 'foo' }] } }
      validator = Fulcrum::ChoiceListValidator.new(data)
      validator.should be_valid
      validator.errors.should be_empty
    end
  end
end