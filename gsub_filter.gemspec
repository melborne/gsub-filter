# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gsub_filter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["kyoendo"]
  gem.email         = ["postagie@gmail.com"]
  gem.description   = %q{Build gsub chain filter}
  gem.summary       = %q{
    This is a text filter for gsub chain. You can set or replace as many gsub filters as you like, then run them through a given text.
    }.strip
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gsub_filter"
  gem.require_paths = ["lib"]
  gem.version       = GsubFilter::VERSION
end
