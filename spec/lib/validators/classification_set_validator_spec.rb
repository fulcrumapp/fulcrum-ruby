require 'spec_helper'

describe Fulcrum::ClassificationSetValidator do
  
  describe '#validates!' do
    it 'should not be valid without a classification_set hash' do
      data = {}
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid if classification_set is not a hash' do
      data = { 'classification_set' => nil }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid without an empty classification_set hash' do
      data = { 'classification_set' => {}}
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
    end
    
    it 'should not be valid without a name' do
      data = { 'classification_set' => { 'name' => '' } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['classification_set']['name'].should_not be_blank
    end
    
    it 'should not be valid without any items' do
      data = { 'classification_set' => { 'name' => 'foobar' } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['classification_set']['items'].should_not be_blank
    end
    
    it 'should not be valid with a non array items element' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> {} } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['classification_set']['items'].should_not be_blank
    end
    
    it 'should not be valid with an empty items array' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> [] } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['classification_set']['items'].should_not be_blank
    end
    
    it 'should not be valid with an empty item' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> [{}] } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['items']['item'].should_not be_blank
    end
    
    it 'should not be valid with a item that does not have label' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> [{ 'foo' => 'bar' }] } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['item']['label'].should_not be_blank
    end
    
    it 'should be valid with a good classification set item' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> [{ 'label' => 'foo' }] } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should be_valid
      validator.errors.should be_empty
    end
    
    # child classifications
    it 'should not be valid if an item has an empty child classifications' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> [{ 'label' => 'bar', 'child_classifications' => [] }] } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should_not be_valid
      validator.errors['child_classification']['item'].should_not be_blank
    end
    
    it 'should be valid with good child classifications' do
      data = { 'classification_set' => { 'name' => 'foobar', 'items'=> [{ 'label' => 'bar', 'child_classifications' => [{ 'label' => 'foo'}] }] } }
      validator = Fulcrum::ClassificationSetValidator.new(data)
      validator.should be_valid
      validator.errors.should be_empty
    end
  end
end