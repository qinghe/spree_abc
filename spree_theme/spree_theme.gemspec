# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_theme'
  s.version     = '2.4.0'
  s.summary     = 'spree theme'
  s.description = 'spree theme'
  s.required_ruby_version = '>= 2.0.0'

  s.author            = 'qinghe'
  s.email             = 'areq22@gmail.com'
  s.homepage          = 'http://www.dalianshops.com'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4'
  s.add_dependency 'friendly_id'
  s.add_dependency 'useragent'
  s.add_dependency 'acts_as_commentable', '3.0.1'
# copy from https://github.com/DynamoMTL/sprangular/gemspec
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
