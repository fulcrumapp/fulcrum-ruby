require 'faraday'
require 'faraday_middleware'

# test api key = 94d6975af5f021b5c6d6b2e473f246e2d6bcf5c83884252c6135d0fee56d7b27

module Fulcrum
  
  class ConnectionError < StandardError; end
  class ApiError < StandardError
    def initialize(message, status)
      super(message)
      @status = status
    end
    
    alias :orig_to_s :to_s
    def to_s
      "#{orig_to_s}, status: #{@status}"
    end
  end
  
  class Api
    
    @@uri = 'http://localhost:3000/api/v2'
    
    attr :connection
    
    def initialize(opts = {})
      @key = opts[:key] || get_key(opts[:username], opts[:password])
      raise ConnectionError, 'no api key' unless @key
      
      @connection = Faraday.new('http://localhost:3000/api/v2', headers: { 'X-ApiToken' => @key,
                                                  user_agent: "Ruby Fulcrum API Client version #{Fulcrum::VERSION}",
                                                  accept: 'application/json' }) do |f|
        f.adapter :net_http
        f.request :multipart
        f.request :url_encoded
        f.response :logger
        f.response :json, :content_type => /\bjson$/
      end
    end
    
    private
    def get_key(username, password)
      conn = Faraday.new(@@uri, headers: {  user_agent: "Ruby Fulcrum API Client version #{Fulcrum::VERSION}",
                                            accept: 'application/json' }) do |f|
        f.adapter :net_http
        f.response :mashify
        f.response :json, :content_type => /\bjson$/
      end
      conn.basic_auth(username, password)
      resp = conn.get('users.json')
      raise ApiError.new('unknown user', resp.status) if !resp.success?
      resp.body.user.api_token
    end
  end
end
