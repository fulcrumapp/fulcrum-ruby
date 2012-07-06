module Fulcrum
  class ClassificationSet < Api
    def self.all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page).to_i if opts[:page]
      end
      @response = connection.get('classification_sets.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.find(id)
      @response = connection.get("classification_sets/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.create(classification_set)
      validation = ClassificationSetValidator.new(classification_set)
      if validation.valid?
        @response = connection.post("classification_sets.json", classification_set)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.update(id, classification_set)
      validation = ClassificationSetValidator.new(classification_set)
      if validation.valid?
        @response = connection.put("classification_sets/#{id}.json", classification_set)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.delete(id)
      @response = connection.delete("classification_sets/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
