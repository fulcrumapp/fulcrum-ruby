require 'faraday'
require 'faraday_middleware'

module Fulcrum

  class Client

    DEFAULT_URL = 'https://api.fulcrumapp.com/api/v2'

    DEFAULT_USER_AGENT = "Fulcrum Ruby API Client, Version #{Fulcrum::VERSION}"

    attr_accessor :connection
    attr_accessor :response
    attr_accessor :key
    attr_accessor :url

    def initialize(key = nil, url = nil)
      self.key = key
      self.url = url || DEFAULT_URL
    end

    def key=(key)
      @key = key
      reset
    end

    def url=(url)
      @url = url
      reset
    end

    def reset
      @response = nil
      @connection = nil
    end

    def call(method = :get, path = '', params = {})
      @response = connection.send(method.to_sym, path, params.with_indifferent_access)
      @response.body
    end

    def connection
      @connection ||= self.class.create_connection(url, key)
    end

    def self.authenticate(username, password, url=DEFAULT_URL)
      connection = create_connection(url)

      connection.basic_auth(username, password)

      resp = connection.get('users.json')

      resp.body['user']['contexts'].map do |context|
        { id: context['id'],
          name: context['name'],
          token: context['api_token'] }
      end
    end

    def self.create_connection(url, key = nil)
      Faraday.new(url) do |connection|
        connection.request  :multipart
        connection.request  :json

        connection.response :raise_error
        connection.response :json, content_type: 'application/json'

        connection.adapter  Faraday.default_adapter

        connection.headers['X-ApiToken'] = key if key
        connection.headers['X-Require-Media'] = 'false'
        connection.headers['User-Agent'] = DEFAULT_USER_AGENT
      end
    end

    def choice_lists
      @choice_lists ||= Fulcrum::ChoiceList.new(self)
    end

    def classification_sets
      @classification_sets ||= Fulcrum::ClassificationSet.new(self)
    end

    def forms
      @forms ||= Fulcrum::Form.new(self)
    end

    def photos
      @photos ||= Fulcrum::Photo.new(self)
    end

    def videos
      @videos ||= Fulcrum::Video.new(self)
    end

    def signatures
      @signatures ||= Fulcrum::Signature.new(self)
    end

    def projects
      @projects ||= Fulcrum::Project.new(self)
    end

    def records
      @records ||= Fulcrum::Record.new(self)
    end

    def memberships
      @memberships ||= Fulcrum::Membership.new(self)
    end

    def layers
      @layers ||= Fulcrum::Layer.new(self)
    end

    def changesets
      @changesets ||= Fulcrum::Changeset.new(self)
    end
  end
end
