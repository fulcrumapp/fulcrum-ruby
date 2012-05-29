module Fulcrum
  class ChoiceList < Api
    def all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
      end
      resp = @connection.get('choice_lists.json')
      raise ApiError.new(resp.body, resp.status) if !resp.success?
      resp.body
    end
    
    def retrieve(id)
      resp = @connection.get("choice_lists/#{id}.json")
      raise ApiError.new(resp.body, resp.status) if !resp.success?
      resp.body
    end
    
    def create(attributes = {})
      resp = @connection.post("choice_lists.json")
    end
    
    def update(id, attributes = {})
      resp = @connection.put("choice_lists/#{id}.json")
    end
    
    def delete(id)
    end
  end
end
