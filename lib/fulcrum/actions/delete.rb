module Fulcrum
  module Actions
    module Delete
      extend ActiveSupport::Concern

      def delete(id)
        call(:delete, member(id))
      end
    end
  end
end

