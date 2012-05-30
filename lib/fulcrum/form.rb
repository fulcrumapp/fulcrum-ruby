module Fulcrum
  class Form < Api
    
    def all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:schema] = opts.delete(:schema) if opts[:schema]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
      end
      @response = @connection.get('forms.json')
      @response.body
    end
    
    def retrieve(id)
      @response = @connection.get("forms/#{id}.json")
      @response.body
    end
    
    def create(form)
      validation = FormValidator.new(form)
      if validation.valid?
        @response = @connection.post("forms.json", form)
        @response.body
      else
        validation.errors
      end
    end
    
    def update(id, form)
      validation = FormValidator.new(form)
      if validation.valid?
        @response = @connection.put("forms/#{id}.json", form)
        @response.body
      else
        validation.errors
      end
    end
    
    def delete(id)
      @response = @connection.delete("forms/#{id}.json")
      @response.body
    end
  end
end