# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fulcrum/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Spatial Networks"]
  gem.email         = ["sniadmin@spatialnetworks.com"]
  gem.description   = %q{Fulcrum API}
  gem.summary       = %q{Fulcrum API client for ruby}
  gem.homepage      = "http://github.com/spatialnetworks/fulcrum-ruby"
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fulcrum"
  gem.require_paths = ["lib"]
  gem.version       = Fulcrum::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'

  gem.add_dependency 'activesupport'
  gem.add_dependency 'faraday', '~> 0.9.0'
  gem.add_dependency 'faraday_middleware'
end
