module Fulcrum
  class ClassificationSetValidator < BaseValidator

    def validate!
      if data['classification_set']
        add_error('classification_set', 'name', 'cannot be blank') if data['classification_set']['name'].blank?

        if data['classification_set']['items'].blank? || !data['classification_set']['items'].kind_of?(Array)
          add_error('classification_set', 'items', 'must be a non-empty array')
        else
          items(data['classification_set']['items'])
        end
      else
        @errors['classification_set'] = ['must exist and not be blank']
      end
      return valid?
    end
    
    def items(elements, child = false)
      parent, child = child ? ['child_classification', 'item'] : ['items', 'item']
      if elements.kind_of?(Array) && !elements.empty?
        elements.each do |element|
          if element.blank?
            add_error(parent, child, 'cannot be empty')
          else
            if element['label'].blank?
              add_error(child, 'label', 'is required')
            end
          end
          items(element['child_classifications'], true) if element.has_key?('child_classifications')
        end
      else
        add_error(parent, child, 'must be a non-empty array')
      end
    end
  end
end

