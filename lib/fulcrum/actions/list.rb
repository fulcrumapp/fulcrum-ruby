module Fulcrum
  module Actions
    module List
      DEFAULT_PER_PAGE = 250

      extend ActiveSupport::Concern

      def default_list_params
        { per_page: DEFAULT_PER_PAGE }
      end

      def all(params = default_list_params)
        result = call(:get, collection, default_list_params.merge(params))

        Page.new(result, resources_name)
      end
    end
  end
end
