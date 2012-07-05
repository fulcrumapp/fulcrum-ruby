module Fulcrum
  class Project < Api

    def self.all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page).to_i if opts[:page]
      end
      @response = connection.get('projects.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.retrieve(id)
      @response = connection.get("projects/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end

    def self.create(project)
      validation = ProjectValidator.new(project)
      if validation.valid?
        @response = connection.post("projects.json", project)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.update(id, project)
      validation = ProjectValidator.new(project)
      if validation.valid?
        @response = connection.put("projects/#{id}.json", project)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end

    def self.delete(id)
      @response = connection.delete("projects/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
