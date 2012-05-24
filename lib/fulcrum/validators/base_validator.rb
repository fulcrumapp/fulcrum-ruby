require 'active_support/core_ext/hash'

module Fulcrum
  class BaseValidator
    attr_accessor :data
    attr_accessor :errors

    def initialize(data)
      @data = (data.is_a?(Hash) ? data : JSON.parse(data)).with_indifferent_access
      @errors = {}
      validate!
    end

    def valid?
      errors.empty?
    end

    def add_error(key, data_name, error)
      if errors.has_key?(key)
        if errors[key].has_key?(data_name)
          errors[key][data_name].push(error)
        else
          errors[key][data_name] = [error]
        end
      else
        errors[key] = {}
        errors[key][data_name] = [error]
      end
    end
  end
end
