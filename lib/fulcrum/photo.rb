module Fulcrum
  class Photo < MediaResource
    def default_content_type
      'image/jpeg'
    end

    def large(id, &blk)
      download_version(id, 'large', &blk)
    end

    def thumbnail(id, &blk)
      download_version(id, 'thumbnail', &blk)
    end
  end
end
