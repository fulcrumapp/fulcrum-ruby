module Fulcrum
  class Record < Api
    def all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
        p[:form_id] = opts.delete(:form_id) if opts[:form_id]
        p[:bounding_box] = opts.delete(:bounding_box) if opts[:bounding_box]
        p[:updated_since] = opts.delete(:updated_since) if opts[:updated_since]
      end
      resp = @connection.get('records.json')
      resp.body
    end
    
    def retrieve(id)
      resp = @connection.get("records/#{id}.json")
      resp.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def create(record)
      validation = RecordValidator.new(record)
      if validation.valid?
        resp = @connection.post("records.json", record)
        resp.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def update(id, record)
      validation = RecordValidator.new(record)
      if validation.valid?
        resp = @connection.put("records/#{id}.json", record)
        resp.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def delete(id)
      resp = @connection.delete("records/#{id}.json")
      resp.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
  end
end