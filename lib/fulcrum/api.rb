require 'faraday'
require 'faraday_middleware'

module Fulcrum

  class ApiError < Faraday::Error::ClientError; end
  class ConnectionError < StandardError; end

  class Api

    VALID_METHODS = [:get, :post, :put, :delete]

    attr :connection
    attr :response
    attr_writer :configuration

    class << self

      def key
        @configuration.key
      end

      def uri
        @configuration.uri
      end

      def response
        @response
      end

      def parse_opts(keys = [], opts = {})
        opts = opts.with_indifferent_access
        {}.tap do |p|
          keys.each { |key| p[key.to_sym] = opts[key] if opts.has_key?(key) }
        end
      end

      def call(method = :get, path = '', params = {})
        raise ArgumentError, "Invalid method: #{method.to_s}" unless VALID_METHODS.include?(method.to_sym)
        @response = connection.send(method.to_sym, path, params)
        @response.body
      rescue Faraday::Error::ClientError => e
        @response = e.response
        { error: { status: @response[:status], message: @response[:body] } }
      end

      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end

      def connection
        if !@connection
          @connection = Faraday.new(Fulcrum::Api.configuration.uri) do |b|
            b.request  :multipart
            b.request  :json
            b.response :raise_error
            b.response :json , :content_type => 'application/json'
            b.adapter  Faraday.default_adapter
          end
          @connection.headers['X-ApiToken'] = Fulcrum::Api.configuration.key
          @connection.headers['User-Agent'] = "Ruby Fulcrum API Client, Version #{Fulcrum::VERSION}"
        end
        @connection
      end

      def get_key(username, password)
        conn = Faraday.new(uri) do |b|
          b.request  :url_encoded
          b.response :raise_error
          b.response :json, :content_type => "application/json"
          b.adapter Faraday.default_adapter
        end

        conn.headers['User-Agent'] = "Ruby Fulcrum API Client version #{Fulcrum::VERSION}"
        conn.basic_auth(username, password)
        resp = conn.get('users.json')
        body = JSON.parse(resp.body)
        if body['user']
          body['user']['api_token']
        else
          nil
        end
      end
    end

    class Configuration
      attr_accessor :uri
      attr_accessor :key
    end
  end
end
