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

    def create(file, attrs = {})
      file = Faraday::UploadIO.new(file, nil)
      response = call(:post, create_action, attrs)
      call(:put, response['url'], {file: file})
      { name: attrs[:name], attachment_id: response['id'] }
    end
  end
end