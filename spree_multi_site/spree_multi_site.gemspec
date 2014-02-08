# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_multi_site'
  s.version     = '1.0.1'
  s.summary     = 'spree extension for multi-site'
  s.description = 'spree extension for multi-site'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'qinghe'
  s.email             = 'areq22@gmail.com'
  s.homepage          = 'http://www.github.com/RuanShan/spree_multi_site'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.2.0'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  #s.add_development_dependency 'sqlite3'
end
