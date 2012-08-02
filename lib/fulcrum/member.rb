module Fulcrum
  class Member < Api

    class << self

      def all(opts = {})
        params = parse_opts([:page], opts)
        call(:get, 'members.json', params)
      end

      def find(id)
        call(:get, "members/#{id}.json")
      end
    end
  end
end
