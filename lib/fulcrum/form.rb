module Fulcrum
  class Form < Api
    def all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:schema] = opts.delete(:schema) if opts[:schema]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
      end
      resp = @connection.get('forms.json')
      raise ApiError.new(resp.body, resp.status) if !resp.success?
      resp.body
    end
    
    def retrieve(id)
      resp = @connection.get("forms/#{id}")
      raise ApiError.new(resp.body, resp.status) if !resp.success?
      resp.body
    end
    
    def create(attributes = {})
    end
    
    def update(attributes = {})
    end
  end
end