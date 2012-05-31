module Fulcrum
  class ClassificationSet < Api
    def all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
      end
      @response = @connection.get('classification_sets.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def retrieve(id)
      @response = @connection.get("classification_sets/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def create(classification_set)
      validation = ClassificationSetValidator.new(classification_set)
      if validation.valid?
        @response = @connection.post("classification_sets.json", classification_set)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def update(id, classification_set)
      validation = ClassificationSetValidator.new(classification_set)
      if validation.valid?
        @response = @connection.put("classification_sets/#{id}.json", classification_set)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def delete(id)
      @response = @connection.delete("classification_sets/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end