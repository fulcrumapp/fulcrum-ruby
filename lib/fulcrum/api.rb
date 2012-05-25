require 'faraday'
require 'faraday_middleware'

# test api key = 94d6975af5f021b5c6d6b2e473f246e2d6bcf5c83884252c6135d0fee56d7b27

module Fulcrum
  
  class ApiError < Faraday::Error::ClientError; end
  class ConnectionError < StandardError; end
  
  class Api
    
    URI = 'http://app.fulcrumapp.com/api/v2'
    
    attr :connection
    
    def initialize(opts = {})
      @uri = opts[:uri] || URI
      @key = opts[:key] || get_key(opts[:username], opts[:password])
      raise ConnectionError, 'no api key' unless @key
      
      @connection = Faraday.new(@uri) do |b|
        b.request :json
        b.response :logger
        b.response :raise_error
        b.response :json, :content_type => "application/json"
        b.adapter Faraday.default_adapter
      end
      
      @connection.headers['X-ApiToken'] = @key
      @connection.headers['User-Agent'] = "Ruby Fulcrum API Client version #{Fulcrum::VERSION}"
    end
    
    private
    def get_key(username, password)
      conn = Faraday.new(@uri) do |b|
        b.response :raise_error
        b.response :mashify
        b.response :json, :content_type => "application/json"
        b.adapter Faraday.default_adapter
      end
      
      conn.headers['User-Agent'] = "Ruby Fulcrum API Client version #{Fulcrum::VERSION}"
      conn.basic_auth(username, password)
      resp = conn.get('users.json')
      resp.body.user.api_token
    end
  end
end
