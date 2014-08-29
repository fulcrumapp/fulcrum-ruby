require 'open-uri'

module Fulcrum
  class MediaResource < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create

    def default_content_type
      raise NotImplementedError,
        'default_content_type must be implemented in derived classes'
    end

    def attributes_for_upload(file, id = new_id, content_type = default_content_type, attrs = {})
      file = Faraday::UploadIO.new(file, content_type)

      resource_attributes = { file: file, access_key: id }

      resource_attributes.merge!(attrs)

      attributes = {}
      attributes[resource_name] = resource_attributes
      attributes
    end

    def create(file, id = new_id, content_type = default_content_type, attrs = {})
      call(:post, create_action, attributes_for_upload(file, id, content_type, attrs))
    end

    def download(url, &blk)
      open(url, "rb", &blk)
    end

    def download_version(id, version, &blk)
      download(find(id)[version], &blk)
    end

    def original(id, &blk)
      download_version(id, 'original', &blk)
    end

    def new_id
      SecureRandom.uuid
    end
  end
end
