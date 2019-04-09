# Fulcrum [![Build Status](https://secure.travis-ci.org/fulcrumapp/fulcrum-ruby.svg)](http://travis-ci.org/fulcrumapp/fulcrum-ruby) [![Gem Version](https://badge.fury.io/rb/fulcrum.svg)](http://badge.fury.io/rb/fulcrum)


Fulcrum API Gem

## Requirements

* Ruby 1.9.3+
* [Fulcrum account](https://web.fulcrumapp.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fulcrum'
```

And then execute:

    bundle

Or install it yourself as:

    gem install fulcrum

## Using the gem

## Client

All interaction with the API is done through a client object. Below is a simple example of how to instantiate a client object.

```ruby
client = Fulcrum::Client.new(your_api_key)
```


## Basics

In general, this API is intended to be a low level wrapper around the Fulcrum API. All of the filtering and query parameters are passed directly through to the HTTP request. It's best to read the [API documentation](http://fulcrumapp.com/developers/api/) to get a sense of the parameters available for each resource. Resource instances are returned from the API as simple hashes.

When using the `create` or `update` methods on resources, the object passed to the method should be in the same format as a result from calling `find` on that resource. For example, you can call `client.records.find(id)` and the result can be used as the parameter for `client.records.update(id, record)`.

Each of the API resources has an `all` method that can be used to fetch a list of resources. The `all` methods accept some basic pagination parameters (`per_page` and `page`) you can use to iterate over the pages. Because the index API's are paginated, the result of `all` is not the objects themselves. The `all` methods return a `Page` object that has some basic attributes to inspect the pagination extents. The `objects` attribute returns the actual array of objects. Below is a simple example that fetches the first page of records from the API.
```ruby

client = Fulcrum::Client.new(your_api_key)

result = client.records.all(form_id: my_form_id, page: 1, per_page: 100)

puts result.class         # Fulcrum::Page
puts result.per_page      # => 100
puts result.current_page  # => 1
puts result.total_pages   # => 2
puts result.total_count   # => 137
puts result.objects.count # => 100
puts result.objects       # [ ... the records ... ]
```

## Records

### client.records.all(params = {})

Retrieve records with optional parameters. For a full list of the available parameters, see the [API documentation](http://fulcrumapp.com/developers/api/records/).

```ruby
client.records.all(page: 1, per_page: 100, form_id: some_form_id, updated_since: timestamp)
```

### client.records.find(id)

Find a single record by its `id` and return a `Hash` of the record attributes.

### client.records.create(record)

Create a new record from a `Hash` of attributes. The format of the attributes is identical to the format returned from `find`. The [record API documentation](http://fulcrumapp.com/developers/api/records) has more information on the format. **Note:** although the raw API uses a hash wrapped in a `record` attribute, this is not necessary for the ruby API. Instead of `{ "record" => record_attributes }`, you simply pass `record_attributes` directly to this method.

### client.records.update(id, record)

Update an existing record by its `id` using a `Hash` of attributes. The format of the attributes is identical to the format returned from `find`. The [record API documentation](http://fulcrumapp.com/developers/api/records) has more information on the format. **Note:** although the raw API uses a hash wrapped in a `record` attribute, this is not necessary for the ruby API. Instead of `{ "record" => record_attributes }`, you simply pass `record_attributes` directly to this method.

### client.records.delete(id, changeset_id=nil)

Delete a record by its `id`. This method optionally accepts a `changeset_id` to group deletes into a Changeset for compatibility with the activity feed.

### client.records.find(id)

Find a record's history by its `id`.



## Forms

### client.forms.all(params = {})

### client.forms.find(id)

### client.forms.create(form)

### client.forms.update(id, form)

### client.forms.delete(id)



## Choice Lists

### client.choice_lists.all(params = {})

### client.choice_lists.find(id)

### client.choice_lists.create(choice_list)

### client.choice_lists.update(id, choice_list)

### client.choice_lists.delete(id)



## Classification Sets

### client.classification_sets.all(params = {})

### client.classification_sets.find(id)

### client.classification_sets.create(classification_set)

### client.classification_sets.update(id, classification_set)

### client.classification_sets.delete(id)



## Projects

### client.projects.all(params = {})

### client.projects.find(id)



## Layers

### client.layers.all(params = {})

### client.layers.find(id)



## Photos

### client.photos.all(params = {})

### client.photos.find(id)

### client.photos.create(file_or_path, content_type = 'image/jpeg', attributes = {})

Create a new photo from a file or a file path. `attributes` must be a `Hash` and currently only accepts 1 attribute, `access_key`.
If you specify an `access_key`, it must be a UUID. If you don't specify an `access_key`, one will be automatically generated and returned in the response.

### client.photos.delete(id)

### client.photos.original(id) {|io| block }

Downloads the original version and yields an IO object to the block. The block is passed an IO object that you can call `#read` on. For example, to download a photo to a file:

```ruby
client.photos.original(id) do |input|
  File.open('output.jpg', 'wb') do |output|
    output.write(input.read)
  end
end
```

### client.photos.thumbnail(id) {|io| block }

Downloads the thumbnail version and yields an IO object to the block.

### client.photos.large(id) {|io| block }

Downloads the large version and yields an IO object to the block.



## Signatures

### client.signatures.all(params = {})

### client.signatures.find(id)

### client.signatures.create(file_or_path, content_type = 'image/png', attributes = {})

Create a new signature from a file or a file path. `attributes` must be a `Hash` and currently only accepts 1 attribute, `access_key`.
If you specify an `access_key`, it must be a UUID. If you don't specify an `access_key`, one will be automatically generated and returned in the response.

### client.signatures.delete(id)

### client.signatures.original(id) {|io| block }

Downloads the original version and yields an IO object to the block.

### client.signatures.thumbnail(id) {|io| block }

Downloads the thumbnail version and yields an IO object to the block.

### client.signatures.large(id) {|io| block }

Downloads the large version and yields an IO object to the block.



## Videos

### client.videos.all(params = {})

### client.videos.find(id)

### client.videos.create(file_or_path, content_type = 'video/mp4', attributes = {})

Create a new video from a file or a file path. `attributes` must be a `Hash` and currently only accepts 2 attributes, `access_key` and `track`.
If you specify an `access_key`, it must be a UUID. If you don't specify an `access_key`, one will be automatically generated and returned in the response.

### client.videos.delete(id)

### client.videos.original(id) {|io| block }

Downloads the original version and yields an IO object to the block.

### client.videos.small(id) {|io| block }

Downloads the small version and yields an IO object to the block.

### client.videos.medium(id) {|io| block }

Downloads the medium version and yields an IO object to the block.

### client.videos.track(id, format='json')

Fetches the GPS track for the specified video.

Format can be 'json', 'geojson', 'gpx', or 'kml'.



## Audio

### client.audio.all(params = {})

### client.audio.find(id)

### client.audio.create(file_or_path, content_type = 'audio/x-m4a', attributes = {})

Create a new audio object from a file or a file path. `attributes` must be a `Hash` and currently only accepts 2 attributes, `access_key` and `track`.
If you specify an `access_key`, it must be a UUID. If you don't specify an `access_key`, one will be automatically generated and returned in the response.

### client.audio.delete(id)

### client.audio.original(id) {|io| block }

Downloads the original version and yields an IO object to the block.

### client.audio.small(id) {|io| block }

Downloads the small version and yields an IO object to the block.

### client.audio.medium(id) {|io| block }

Downloads the medium version and yields an IO object to the block.

### client.audio.track(id, format='json')

Fetches the GPS track for the specified audio.

Format can be 'json', 'geojson', 'gpx', or 'kml'.



## Memberships

### client.memberships.all(params = {})



## Changesets

### client.changesets.all(params = {})

### client.changesets.find(id)

### client.changesets.create(changeset)

### client.changesets.update(id, changeset)

### client.changesets.close(id, changeset = {})



## Webhooks

### client.webhooks.all(params = {})

### client.webhooks.find(id)

### client.webhooks.create(webhook)

### client.webhooks.update(id, webhook)

### client.webhooks.delete(id)

## Roles

### client.roles.all(params = {})

## Audit Logs

### client.audit_logs.all(params = {})

### client.audit_logs.find(id)

## Extra Reading

* [Fulcrum API documentation](http://fulcrumapp.com/developers/api/)

## Contributing

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

