module Fulcrum
  class Video < MediaResource
    include MediaVersions

    def default_content_type
      'video/mp4'
    end

    def create_action
      'videos/upload'
    end

    def track(id)
      call(:get, member_action(id, 'track'))
    end
  end
end
