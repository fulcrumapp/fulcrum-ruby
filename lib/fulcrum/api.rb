require 'faraday'
require 'faraday_middleware'

# test api key = 94d6975af5f021b5c6d6b2e473f246e2d6bcf5c83884252c6135d0fee56d7b27

module Fulcrum

  class ApiError < Faraday::Error::ClientError; end
  class ConnectionError < StandardError; end

  class Api

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

      def connection
        @connection
      end

      def response
        @response
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
