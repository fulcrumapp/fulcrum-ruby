module Fulcrum
  class Project < Api
    
    def all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
      end
      @response = @connection.get('projects.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def retrieve(id)
      @response = @connection.get("projects/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def create(project)
      validation = ProjectValidator.new(project)
      if validation.valid?
        @response = @connection.post("projects.json", project)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def update(id, project)
      validation = ProjectValidator.new(project)
      if validation.valid?
        @response = @connection.put("projects/#{id}.json", project)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def delete(id)
      @response = @connection.delete("projects/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
