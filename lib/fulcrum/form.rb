module Fulcrum
  class Form < Api
    def all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:schema] = opts.delete(:schema) if opts[:schema]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
      end
      resp = @connection.get('forms.json')
      resp.body
    end
    
    def retrieve(id)
      resp = @connection.get("forms/#{id}.json")
      resp.body
    end
    
    def create(form)
      validation = FormValidator.new(form)
      if validation.valid?
        resp = @connection.post("forms.json", form)
        resp.body
      else
        validation.errors
      end
    end
    
    def update(id, form)
      validation = FormValidator.new(form)
      if validation.valid?
        resp = @connection.put("forms/#{id}.json", form)
        resp.body
      else
        validation.errors
      end
    end
    
    def delete(id)
      resp = @connection.delete("forms/#{id}.json")
      resp.body
    end
  end
end