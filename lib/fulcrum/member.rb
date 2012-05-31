module Fulcrum
  class Member
    
    def all
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
      end
      @response = @connection.get('members.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def retrieve(id)
      @response = @connection.get("members/#{id}.json", params)
      @response.body      
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
