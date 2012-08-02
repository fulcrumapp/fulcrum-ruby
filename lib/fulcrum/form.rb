module Fulcrum
  class Form < Api

    class << self

      def all(opts = {})
        params = self.parse_opts([:page, :schema], opts)
        self.call(:get, 'forms.json', params)
      end

      def find(id, opts = {})
        params = parse_opts([:include_foreign_elements], opts)
        call(:get, "forms/#{id}.json", params)
      end

      def create(form)
        validation = FormValidator.new(form)
        if validation.valid?
          call(:post, "forms.json", form)
        else
          { error: { validation: { validation.errors } }
        end
      end

      def update(id, form)
        validation = FormValidator.new(form)
        if validation.valid?
          call(:put, "forms/#{id}.json", form)
        else
          { error: { validation: { validation.errors } }
        end
      end

      def delete(id)
        call(:delete, "forms/#{id}.json")
      end
    end
  end
end
