module Fulcrum
  class Photo < Api
    def retrieve(id, opts = {})
      opts = opts.with_indifferent_access
      format = opts.delete(:format) || 'jpg'
      @response = @connection.get("photos/#{id}.#{format}")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def thumbnail(id)
      @response = @connection.get("photos/#{id}/thumbnail.jpg")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def create(file_path, content_type, id, label = '')
      photo_file = Faraday::UploadIO.new(file_path, content_type)
      @response = @connection.post("photos", { photo: { file: photo_file, access_key: id, label: label }})
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end
    
    def delete(id)
      @response = @connection.delete("photos/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
