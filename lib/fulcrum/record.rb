module Fulcrum
  class Record < Api
    def self.all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page).to_i if opts.has_key?(:page)
        p[:form_id] = opts.delete(:form_id).to_s if opts.has_key?(:form_id)
        p[:bounding_box] = opts.delete(:bounding_box) if opts.has_key?(:bounding_box)
        p[:updated_since] = opts.delete(:updated_since) if opts.has_key?(:updated_since)
      end
      @response = connection.get('records.json')
      @response.body
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.message)
    end

    def self.find(id)
      @response = connection.get("records/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.response)
    end

    def self.create(record)
      validation = RecordValidator.new(record)
      if validation.valid?
        @response = connection.post("records.json", record)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.response)
    end

    def self.update(id, record)
      validation = RecordValidator.new(record)
      if validation.valid?
        @response = connection.put("records/#{id}.json", record)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.response)
    end

    def self.delete(id)
      @response = connection.delete("records/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.response)
    end
  end
end
