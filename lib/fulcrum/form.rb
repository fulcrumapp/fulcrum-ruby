module Fulcrum
  class Form < Api

    def self.all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page).to_i if opts[:page]
        p[:schema] = opts.delete(:schema).to_s if opts[:schema]
      end
      @response = connection.get('forms.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.find(id, opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:include_foreign_elements] = opts.delete(:include_foreign_elements).to_s if opts[:include_foreign_elements]
      end
      @response = connection.get("forms/#{id}.json", params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end

    def self.create(form)
      validation = FormValidator.new(form)
      if validation.valid?
        @response = connection.post("forms.json", form)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.update(id, form)
      validation = FormValidator.new(form)
      if validation.valid?
        @response = connection.put("forms/#{id}.json", form)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.delete(id)
      @response = connection.delete("forms/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
