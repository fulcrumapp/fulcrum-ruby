module Fulcrum
  class Resource
    DEFAULT_PER_PAGE = 250

    attr_accessor :client

    def initialize(client)
      self.client = client
    end

    def resource_name
      self.class.to_s.split('::').last.underscore
    end

    def resources_name
      resource_name.pluralize
    end

    def call(method = :get, path = '', params = {})
      client.call(method, path, params)
    end

    def collection(format = 'json')
      "#{resources_name}.#{format}"
    end

    def member(id, format = 'json')
      "#{resources_name}/#{id}.#{format}"
    end

    def member_action(id, action, format = 'json')
      "#{resources_name}/#{id}/#{action}.#{format}"
    end

    def create_action
      collection
    end

    def default_index_params
      { per_page: DEFAULT_PER_PAGE }
    end

    def attributes_for_object(object)
      attributes = {}
      attributes[resource_name] = object
      attributes
    end

    def all(params = default_index_params)
      result = call(:get, collection, params)

      Page.new(result, resources_name)
    end

    def find(id)
      call(:get, member(id))[resource_name]
    end

    def create(object)
      call(:post, collection, attributes_for_object(object))[resource_name]
    end

    def update(id, object)
      call(:put, member(id), attributes_for_object(object))[resource_name]
    end

    def delete(id)
      call(:delete, member(id))
    end

  end
end

