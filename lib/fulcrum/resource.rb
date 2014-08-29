module Fulcrum
  class Resource
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

    def attributes_for_object(object)
      attributes = {}
      attributes[resource_name] = object
      attributes
    end
  end
end

