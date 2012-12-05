module Fulcrum
  class Project < Api

    class << self

      def all(opts = {})
        params = parse_opts([:page, :updated_since], opts)
        call(:get, 'projects.json', params)
      end

    end
  end
end

