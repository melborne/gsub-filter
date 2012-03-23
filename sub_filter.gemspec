Gem::Specification.new do |gem|
  gem.name          = 'sub_filter'
  gem.version       = '0.1.0'
  gem.platform      = Gem::Platform::RUBY
  gem.author        = 'Kyo Endo'
  gem.email         = "postagie@gmail.com"
  gem.summary       = "Build substring chain filters"
  gem.description   = "Build substring chain filters easily"
  
  gem.files         = ['sub_filter.rb']
  gem.test_file     = 'sub_filter_spec.rb'
  gem.require_path  = '.'

  gem.add_development_dependency('rspec', ["~> 2.0"])
end
