module Fulcrum
  class ChoiceList < Api
    def all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page).to_i if opts[:page]
      end
      @response = @connection.get('choice_lists.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def retrieve(id)
      @response = @connection.get("choice_lists/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def create(choice_list)
      validation = ChoiceListValidator.new(choice_list)
      if validation.valid?
        @response = @connection.post("choice_lists.json", choice_list)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def update(id, choice_list)
      validation = ChoiceListValidator.new(choice_list)
      if validation.valid?
        @response = @connection.put("choice_lists/#{id}.json", choice_list)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
    
    def delete(id)
      @response = @connection.delete("choice_lists/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
