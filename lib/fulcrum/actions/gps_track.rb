module Fulcrum
  module GpsTrack
    extend ActiveSupport::Concern

    def track(id, format='json')
      call(:get, member_action(id, 'track', format))
    end
  end
end
