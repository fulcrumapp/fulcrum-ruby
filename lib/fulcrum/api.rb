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

    def key
      @configuration.key
    end

    def host
      @configuration.host
    end

    def self.connection
      @connection
    end

    def self.response
      @response
    end

    def self.configure(silent = false)
      yield(configuration)
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.connection
      if !@connection
        @connection = Faraday.new(Fulcrum::Api.configuration.uri) do |b|
          b.request  :multipart
          b.request  :url_encoded
          b.response :logger
          b.response :raise_error
          b.response :json, :content_type => 'appliation/json'
          b.adapter  Faraday.default_adapter
        end
        @connection.headers['X-ApiToken'] = Fulcrum::Api.configuration.key
        @connection.headers['User-Agent'] = "Ruby Fulcrum API Client, Version #{Fulcrum::VERSION}"
      end
      @connection
    end

    def self.get_key(username, password)
      conn = Faraday.new(uri) do |b|
        b.request  :url_encoded
        b.response :raise_error
        b.response :json, :content_type => "application/json"
        b.adapter Faraday.default_adapter
      end

      conn.headers['User-Agent'] = "Ruby Fulcrum API Client version #{Fulcrum::VERSION}"
      conn.basic_auth(username, password)
      resp = conn.get('users.json')
      resp.body['user']['api_token']
    end

    class Configuration
      attr_accessor :uri
      attr_accessor :key
    end
  end
end
