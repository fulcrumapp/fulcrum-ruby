module Fulcrum
  class Photo < Api

    ALLOWED_FORMATS = %w(json jpg)
    ALLOWED_IMAGE_TYPES = %(png jpg)

    def self.find(id, opts = {})
      opts = opts.with_indifferent_access
      format = opts.delete(:format).to_s || 'jpg'
      raise ::ArgumentError "#{format} is not an allowed format, use either 'json' or 'jpg'" if !ALLOWED_FORMATS.include?(format)
      @response = connection.get("photos/#{id}.#{format}")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end

    def self.thumbnail(id)
      @response = connection.get("photos/#{id}/thumbnail.jpg")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end

    def self.create(file, content_type, id, label = '')
      photo = Faraday::UploadIO.new(file, content_type)
      @response = connection.post("photos", { photo: { file: photo, access_key: id, label: label }})
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.response)
    end

    def self.delete(id)
      @response = connection.delete("photos/#{id}.json")
      @response.body
    rescue Faraday::Error::ClientError => e
      raise ApiError.new(e, e.message)
    end
  end
end
