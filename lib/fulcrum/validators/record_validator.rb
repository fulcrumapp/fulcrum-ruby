module Fulcrum
  class RecordValidator < BaseValidator
    def validate!
      if data['record'].kind_of?(Hash) && !data['record'].empty?
        add_error('record', 'form_id', 'cannot be blank') if data['record']['form_id'].blank?
        if data['record']['latitude'].to_f == 0.0 || data['record']['longitude'] == 0.0
          add_error('record', 'coordinates', 'must be in WGS84 format')
        end
        if !data['record']['form_values'].kind_of?(Hash) || data['record']['form_values'].blank?
          add_error('record', 'form_values', 'must be a non-empty hash')
        end
      else
        @errors['record'] = ['must be a non-empty hash']
      end
      return valid?
    end
  end
end
