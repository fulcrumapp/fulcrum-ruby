module Fulcrum
  class Audio < MediaResource
    include MediaVersions
    include GpsTrack

    def resources_name
      resource_name
    end

    def default_content_type
      'audio/x-m4a'
    end

    def create_action
      'audio/upload'
    end
  end
end
