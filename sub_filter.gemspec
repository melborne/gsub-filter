# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Kyo Endo"]
  gem.email         = ["postagie@gmail.com"]
  gem.description   = %q{Build substring chain filters easily}
  gem.summary       = %q{Build substring chain filters}
  gem.homepage      = ""

  gem.files         = ['sub_filter.rb']
  gem.test_files    = 'sub_filter_spec.rb'
  gem.name          = "sub_filter"
  gem.require_path  = '.'
  gem.version       = SubFilter::VERSION

  gem.add_development_dependency('rspec', ["~> 2.0"])
end
