require 'faraday'
require 'faraday_middleware'

# test api key = 94d6975af5f021b5c6d6b2e473f246e2d6bcf5c83884252c6135d0fee56d7b27

module Fulcrum
  
  class ApiError < Faraday::Error::ClientError; end
  class ConnectionError < StandardError; end
  
  class Api
    
    @@uri = 'http://app.fulcrumapp.com/api/v2'
    @@key = nil
    
    attr :connection
    attr :response
    
    def key
      @key || @@key
    end
    
    def uri
      @uri || @@uri
    end
    
    def initialize(opts = {})
      @uri = @@uri = opts[:uri] || @@uri
      @key = @@key = opts[:key] || @@key || get_key(opts[:username], opts[:password])
      raise ConnectionError, 'no api key' unless key
      
      @connection = Faraday.new(uri) do |b|
        b.request  :multipart
        b.request  :url_encoded
        b.response :logger
        b.response :raise_error
        b.response :json, :content_type => "application/json"
        b.adapter Faraday.default_adapter
      end
      
      @connection.headers['X-ApiToken'] = key
      @connection.headers['User-Agent'] = "Ruby Fulcrum API Client version #{Fulcrum::VERSION}"
    end
    
    private
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
      resp.body['user']['api_token']
    end
  end
end
