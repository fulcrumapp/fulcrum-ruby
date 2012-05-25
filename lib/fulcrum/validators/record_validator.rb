module Fulcrum
  class RecordValidator < BaseValidator

    def validate!
      if data[:record]
        @errors['form_id'] = ["must have a form id"] if data[:record][:form_id].blank?
        if data[:record][:latitude].to_f == 0.0 || data[:record][:longitude] == 0.0
          @errors['coordinates'] = ["coordinates must be in WGS84 format"]
        end
        @errors['form_values'] = ['must have a form_values hash and not be empty'] if data[:record][:form_values].blank?
      else
        @errors['record'] = ['record cannot be blank']
      end
    end
  end
end
