# Fulcrum

Fulcrum API Gem

## Installation

Add this line to your application's Gemfile:

    gem 'fulcrum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fulcrum

## Usage

    Fulcrum::Api.configure do |config|
      config.uri = 'http://web.fulcrumapp.com/api/v2'
      config.key = 'your_api_key'
    end

    forms = Fulcrum::Form.all
    form = Fulcrum::Form.find(id)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
