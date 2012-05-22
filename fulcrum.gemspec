# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fulcrum/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Hall"]
  gem.email         = ["chris@spatialnetworks.com"]
  gem.description   = %q{Fulcrum API Gem}
  gem.summary       = %q{Fulcrum API Gem}
  gem.homepage      = "http://docs.fulcrumapp.com/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fulcrum"
  gem.require_paths = ["lib"]
  gem.version       = Fulcrum::VERSION
end
