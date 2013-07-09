# Fulcrum

Fulcrum API Gem

## Requirements

ruby 1.9.x
a [fulcrum user account](http://web.fulcrumapp.com)

## Installation

Add this line to your application's Gemfile:

    gem 'fulcrum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fulcrum

## Configuration

    Fulcrum::Api.configure do |config|
      config.uri = 'http://web.fulcrumapp.com/api/v2'
      config.key = 'your_api_key'
    end

## Projects

    Fulcrum::Project.all(opts)
    # opts = { 'page' => page_number,
    #          'updated_since' => date_time }

## Forms

```ruby
Fulcrum::Form.all(opts)
# opts = { 'page' => page_number,
#          'schema' => true_or_false }

Fulcrum::Form.find(id, opts)
# opts = { 'include_foreign_elements' => true_or_false }

Fulcrum::Form.create(form)
# form = { 'form' => { ... } }

Fulcrum::Form.update(id, form)
# form = { 'form' => { ... } }

Fulcrum::Form.delete(id)
```

## Records

    Fulcrum::Record.all(opts)
    # opts = { 'page' => page_number,
    #          'form_id' => form_id,
    #          'bounding_box' => 'lat_bottom,lng_left,lat_top,lng_right',
    #          'updated_since' => date_since_epoch_in_seconds }

    Fulcrum::Record.find(id)
    Fulcrum::Record.create(record)
    # record = { 'record' => { ... } }

    Fulcrum::Record.update(id, record)
    # record = { 'record' => { ... } }

    Fulcrum::Record.delete(id)

## Photos

    Fulcrum::Photo.find(access_key, opts)
    # opts = { 'format' => 'json|jpg' }, defaults to 'json'

    Fulcrum::Photo.thumbnail(access_key, opts)
    # opts = { 'format' => 'json|jpg' }, defaults to 'json'

    Fulcrum::Photo.create(photo, content_type, unique_id, label)

    Fulcrum::Photo.delete(access_key)

## Choice Lists

    Fulcrum::ChoiceList.all(opts)
    # opts = { 'page' => page_number }

    Fulcrum::ChoiceList.find(id)

    Fulcrum::ChoiceList.create(choice_list)
    # choice_list = { 'choice_list' => { ... } }

    Fulcrum::ChoiceList.update(id, choice_list)
    # choice_list = { 'choice_list' => { ... } }

    Fulcrum::ChoiceList.delete(id)

## Classification Sets

    Fulcrum::ClassificationSet.all(opts)
    # opts = { 'page' => page_number }

    Fulcrum::ClassificationSet.find(id)

    Fulcrum::ClassificationSet.create(classification_set)
    # classification_set = { 'classification_set' => { ... } }

    Fulcrum::ClassificationSet.update(id, classification_set)
    # classification_set = { 'classification_set' => { ... } }

    Fulcrum::ClassificationSet.delete(id)

## Members

    Fulcrum::Member.all(opts)
    # opts = { 'page' => page_number }

    Fulcrum::Member.find(id)

## Extra Reading

  [Fulcrum API docs](http://developer.fulcrumapp.com/api/fulcrum-api.html)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
