module Fulcrum
  class ClassificationSet < Api
    def all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
      end
      resp = @connection.get('classification_sets.json')
      raise ApiError.new(resp.body, resp.status) if !resp.success?
      resp.body
    end
    
    def retrieve(id)
      resp = @connection.get("classification_sets/#{id}.json")
      raise ApiError.new(resp.body, resp.status) if !resp.success?
      resp.body
    end
    
    def create(attributes = {})
      resp = @connection.post("classification_sets.json")
    end
    
    def update(id, attributes = {})
      resp = @connection.put("classification_sets/#{id}.json")
    end
    
    def delete(id)
    end
  end
end