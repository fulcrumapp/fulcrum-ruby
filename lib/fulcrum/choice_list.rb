module Fulcrum
  class ChoiceList < Api
    def self.all(opts = {})
      opts = opts.with_indifferent_access
      params = {}.tap do |p|
        p[:page] = opts.delete(:page).to_i if opts.has_key?(:page)
      end
      @response = connection.get('choice_lists.json', params)
      @response.body
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.message)
    end

    def self.find(id)
      @response = connection.get("choice_lists/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.message)
    end

    def self.create(choice_list)
      validation = ChoiceListValidator.new(choice_list)
      if validation.valid?
        @response = connection.post("choice_lists.json", choice_list)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.message)
    end

    def self.update(id, choice_list)
      validation = ChoiceListValidator.new(choice_list)
      if validation.valid?
        @response = connection.put("choice_lists/#{id}.json", choice_list)
        @response.body
      else
        validation.errors
      end
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.message)
    end

    def self.delete(id)
      @response = connection.delete("choice_lists/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      @response = e.response
      raise ApiError.new(e, e.message)
    end
  end
end
