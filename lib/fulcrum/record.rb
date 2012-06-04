module Fulcrum
  class Record < Api
    def all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:form_id] = opts.delete(:form_id) if opts[:form_id]
        p[:bounding_box] = opts.delete(:bounding_box) if opts[:bounding_box]
        p[:updated_since] = opts.delete(:updated_since) if opts[:updated_since]
      end
      @response = @connection.get('records.json')
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def retrieve(id)
      @response = @connection.get("records/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def create(record)
      validation = RecordValidator.new(record)
      if validation.valid?
        @response = @connection.post("records.json", record)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def update(id, record)
      validation = RecordValidator.new(record)
      if validation.valid?
        @response = @connection.put("records/#{id}.json", record)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def delete(id)
      @response = @connection.delete("records/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
  end
end