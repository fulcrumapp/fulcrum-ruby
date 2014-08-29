module Fulcrum
  module Actions
    module Find
      extend ActiveSupport::Concern

      def find(id)
        call(:get, member(id))[resource_name]
      end
    end
  end
end
