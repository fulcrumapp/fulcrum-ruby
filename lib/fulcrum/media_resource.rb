require 'open-uri'

module Fulcrum
  class MediaResource < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create

    class Fulcrum::MediaNotAvailableError < StandardError; end

    def default_content_type
      raise NotImplementedError,
        'default_content_type must be implemented in derived classes'
    end

    def attributes_for_upload(file, content_type = nil, attributes = {})
      attributes ||= {}

      file = Faraday::UploadIO.new(file, content_type || default_content_type)

      attributes[:file] = file
      attributes[:access_key] ||= new_access_key

      media_attributes = {}
      media_attributes[resource_name] = attributes
      media_attributes
    end

    def create(file, content_type = nil, attrs = {})
      call(:post, create_action, attributes_for_upload(file, content_type, attrs))
    end

    def download(url, &blk)
      open(url, "rb", &blk)
    end

    def download_version(access_key, version, &blk)
      media = find(access_key)

      unless media[version]
        raise Fulcrum::MediaNotAvailableError, "The #{resource_name} version you requested is not available."
      end

      download(media[version], &blk)
    end

    def original(access_key, &blk)
      download_version(access_key, 'original', &blk)
    end

    def new_access_key
      SecureRandom.uuid
    end
  end
end
