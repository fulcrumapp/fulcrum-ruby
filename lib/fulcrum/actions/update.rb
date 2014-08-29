module Fulcrum
  module Actions
    module Update
      extend ActiveSupport::Concern

      def update(id, object)
        call(:put, member(id), attributes_for_object(object))[resource_name]
      end
    end
  end
end
