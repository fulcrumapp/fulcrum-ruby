module Fulcrum
  class Attachment < MediaResource
    include Actions::Delete

    def finalize(id)
      call(:post, "#{collection}/finalize", {id: id})
    end

    def collection
      resources_name
    end

    def member(id)
      "#{resources_name}/#{id}"
    end

    def find(id)
      call(:get, member(id))
    end

    def all(params = {})
      call(:get, collection, params)
    end

    def create(file, attrs = {})
      response = call(:post, create_action, attrs)
      binary_upload(file, response['url'], attrs[:file_size])
      { name: attrs[:name], attachment_id: response['id'] }
    end

    private

    def binary_upload(file, url, file_size)
      connection = Faraday.new(url: url) do |faraday|
        faraday.request :multipart
        faraday.adapter :net_http
      end
      connection.put do |req|
        req.headers['Content-Type'] = 'octet/stream'
        req.headers['Content-Length'] = "#{file_size}"
        req.headers['Content-Transfer-Encoding'] = 'binary'
        req.body = Faraday::UploadIO.new(file, 'octet/stream')
      end
    end
  end
end