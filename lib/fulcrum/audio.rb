module Fulcrum
  class Audio < MediaResource
    def resources_name
      resource_name
    end

    def default_content_type
      'audio/x-m4a'
    end

    def create_action
      'audio/upload'
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
