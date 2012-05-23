require 'faraday'
require 'faraday_middleware'

# test api key = 94d6975af5f021b5c6d6b2e473f246e2d6bcf5c83884252c6135d0fee56d7b27

module Fulcrum
  
  class ApiError < StandardError; end
  
  class Api
    
    @@uri = 'http://localhost:3000/api/v2'
    
    attr :connection
    
    def initialize(opts = {})
      if opts[:username] && opts[:password]
        connection = Faraday.new(@@uri, headers: {  user_agent: "Ruby Fulcrum API Client version #{Fulcrum::VERSION}",
                                                    accept: 'application/json' }) do |f|
        connection.basic_auth(opts[:username], opts[:password])
        user = connection.get('users.json').body
        raise ApiError, 'unknown user' if user.empty?
        opts[:key] = user['api_token']
      end
      
      raise ApiError, 'no api key' unless opts[:key]
      
      @connection = Faraday.new(@@uri,
                                headers: { 'X-ApiToken' => opts[key],
                                           user_agent: "Ruby Fulcrum API Client version #{Fulcrum::VERSION}",
                                           accept: 'application/json' }) do |f|
        f.adapter :net_http
        f.request :multipart
        f.request :url_encoded
        f.response :logger
        f.response :json, :content_type => /\bjson$/
        f.response :mashify
      end
    end
  end
end
