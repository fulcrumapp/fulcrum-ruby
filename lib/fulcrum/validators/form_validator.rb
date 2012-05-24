module Fulcrum
  class FormValidator < BaseValidator

    TYPES = %w(
      TextField
      ChoiceField
      ClassificationField
      PhotoField
      DateTimeField
      Section
    )

    def form_elements
      data['form']['elements']
    end
    
    def form_name
      data['form']['name']
    end

    def validate!
      @items  = {}
      if data[:form]
        if form_elements && !form_elements.empty?
          @errors['form'] = { name: 'cannot be blank' } if form_name.blank?
          fields(form_elements)
          conditionals(form_elements)
        else
          @errors['form'] = ['must have an elements array and not be empty']
        end
      else
        @errors['form'] = ['form cannot be blank']
      end
    end

    def fields(elements)
      elements.each { |element| field(element) }
    end

    def field(element)
      if element.blank?
        @errors['elements'] = 'elements cannot contain an empty element'
      else
        if @items.include?(element[:key])
          add_error(element[:key], :key, 'key must be unique')
          return false
        end

        key = element[:key]

        @items[key] = element[:type]

        add_error(key, :label, 'is required') if element[:label].blank?
        add_error(key, :data_name, 'is required') if element[:data_name].blank?
        add_error(key, :type, 'is not one of the valid types') unless TYPES.include?(element[:type])

        %w(disabled hidden required).each do |attrib|
          add_error(key, attrib, 'must be true or false') unless [true, false].include?(element[attrib])
        end

        case element[:type]

        when 'ClassificationField'
          add_error(key, :classification_set_id, 'is required') if element[:classification_set_id].blank?

          add_error(key, :classification_set_id, 'does not exist') unless ::ClassificationSet.where(_id: element[:classification_set_id]).first

        when 'Section'
          if element[:elements].is_a?(Array)
            if element[:elements].any?
              fields(element[:elements])
            else
              add_error(key, :elements, 'must contain additional elements')
            end
          else
            add_error(key, :elements, 'must be an array object')
          end

        when 'ChoiceField'
          if element[:choice_list_id]
            add_error(key, :choice_list_id, 'does not exist') unless ::ChoiceList.find(element[:choice_list_id])
          else
            if element[:choices].is_a?(Array)
              add_error(key, :choices, 'must not be empty') if element[:choices].blank?
              element[:choices].each do |choice|
                unless choice.has_key?(:label) && choice[:label].present?
                  add_error(key, :choices, 'contains an invalid label')
                end
              end
            else
              add_error(key, :choices, 'must be an array object')
            end
          end
        end
      end
    end

    def conditionals(elements)
      elements.each { |element| conditional(element) }
    end

    def conditional(element)

      operators = case element[:type]
      when 'ChoiceField', 'ClassificationField'
        %w(equal_to not_equal_to is_empty is_not_empty)
      else
        %w(equal_to not_equal_to contains starts_with greater_than less_than is_empty is_not_empty)
      end

      %w(required_conditions visible_conditions).each do |field|

        if type = element["#{field}_type"]
          add_error(key, "#{field}_type", 'is not valid') unless %(any all).include?(type)
        end

        if element[field]
          if element[field].is_a?(Array)
            element[field].each do |condition|

              if key = condition[:field_key]
                add_error(key, field, "key #{key} does not exist on the form") unless @items.keys.include?(key)
                add_error(key, field, "operator for #{key} is invalid") unless operators.include?(condition[:operator])

                if %w(is_empty is_not_empty).include?(condition[:operator]) && condition[:value].present?
                  add_error(key, field, 'value cannot be blank')
                end
              else
                add_error(key, field, 'field key must exist for condition')
              end

            end
          else
            add_error(key, field, 'must be an array object')
          end
        end
      end

      conditionals(element[:elements]) if element[:type] == 'Section'
    end
  end
end
