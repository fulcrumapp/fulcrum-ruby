require 'faraday'
require 'faraday_middleware'

# test api key = 94d6975af5f021b5c6d6b2e473f246e2d6bcf5c83884252c6135d0fee56d7b27

module Fulcrum
  
  class ApiError < StandardError; end
  
  class Api
    
    @@key = nil
    @@uri = 'http://localhost:3000/api/v2'
    @connection = nil
    
    def self.key=(k)
      @@key = k
    end
    
    def self.key
      @@key
    end
    
    def self.connection
      raise ApiError, 'API Key not set' if !@@key
      @@connection ||= Faraday.new(@@uri,
                                headers: { 'X-ApiToken' => @@key,
                                           :user_agent => "Ruby Fulcrum API Client version #{Fulcrum::VERSION}",
                                           :accept => 'application/json' }) do |f|
        f.adapter :net_http
        f.request :multipart
        f.request :url_encoded
        f.response :logger
        f.response :json, :content_type => /\bjson$/
        f.response :mashify
      end
      @@connection
    end
  end
  
  class Form < Api
    
    def self.retrieve(id)
      connection.get("forms/#{id}").body
    end
    
    def self.all(opts = {})
      params = {}.tap do |p|
        p[:page] = opts.delete(:page) if opts[:page]
        p[:schema] = opts.delete(:schema) if opts[:schema]
        p[:per_page] = opts.delete(:per_page) if opts[:per_page]
      end
      
      connection.get("forms", params).body
    end
  end
end