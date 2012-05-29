module Fulcrum
  class ChoiceListValidator < BaseValidator

    def validate!
      if data['choice_list'].kind_of?(Hash) && !data['choice_list'].blank?
        add_error('choice_list', 'name', 'must not be blank') if data['choice_list']['name'].blank?
        choices(data['choice_list']['choices'])
      else
        @errors['choice_list'] = ['must be a non-empty hash']
      end
      return valid?
    end
    
    def choices(elements)
      if elements.kind_of?(Array) && !elements.empty?
        elements.each do |choice|
          if choice.blank?
            add_error('choices', 'choice', 'cannot be empty')
          else
            if choice['label'].blank?
              add_error('choice', 'label', 'is required')
            end
          end
        end
      else
        add_error('choice_list', 'choices', 'must be a non-empty array')
      end
    end
  end
end
