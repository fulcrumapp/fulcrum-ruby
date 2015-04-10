module Fulcrum
  module GpsTrack
    extend ActiveSupport::Concern

    def track(id)
      call(:get, member_action(id, 'track'))
    end
  end
end
