module Fulcrum
  module MediaVersions
    extend ActiveSupport::Concern

    def small(id, &blk)
      download_version(id, 'small', &blk)
    end

    def medium(id, &blk)
      download_version(id, 'medium', &blk)
    end
  end
end
