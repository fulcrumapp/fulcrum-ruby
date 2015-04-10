module Fulcrum
  class Video < MediaResource
    include MediaVersions
    include GpsTrack

    def default_content_type
      'video/mp4'
    end

    def create_action
      'videos/upload'
    end
  end
end
