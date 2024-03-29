# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fulcrum/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Fulcrum"]
  gem.email         = ["info@fulcrumapp.com"]
  gem.description   = %q{Fulcrum API}
  gem.summary       = %q{Fulcrum API client for ruby}
  gem.homepage      = "https://github.com/fulcrumapp/fulcrum-ruby"
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
  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
end
