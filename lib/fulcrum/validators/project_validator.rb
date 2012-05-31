module Fulcrum
  class ProjectValidator < BaseValidator
    def validate!
      if data['project'].kind_of?(Hash) && !data['project'].empty?
        add_error('project', 'title', 'cannot be blank') if data['project']['title'].blank?
        if data['project']['member_ids'] && data['project']['member_ids'].blank?
          add_error('project', 'member_ids', 'must be a non-empty array')
        end
        if data['project']['form_ids'] && data['project']['form_ids'].blank?
          add_error('project', 'form_ids', 'must be a non-empty array')
        end
      else
        @errors['project'] = ['must be a non-empty hash']
      end
      return valid?
    end
  end
end