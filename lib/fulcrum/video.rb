module Fulcrum
  class Video < MediaResource
    def default_content_type
      'video/mp4'
    end

    def create_action
      'videos/upload'
    end

    def small(id, &blk)
      download_version(id, 'small', &blk)
    end

    def medium(id, &blk)
      download_version(id, 'medium', &blk)
    end

    def track(id)
      call(:get, member_action(id, 'track'))
    end
  end
end
