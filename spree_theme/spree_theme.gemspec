# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_theme'
  s.version     = '2.4.0'
  s.summary     = 'spree theme'
  s.description = 'spree theme'
  s.required_ruby_version = '>= 1.9.3'

  s.author            = 'qinghe'
  s.email             = 'areq22@gmail.com'
  s.homepage          = 'http://www.dalianshops.com'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4'
  s.add_dependency 'spree_api', '~> 2.4'
  s.add_dependency 'friendly_id'
  # copy from https://github.com/DynamoMTL/sprangular/gemspec
  s.add_dependency 'slim-rails'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'angularjs-rails'
  s.add_dependency 'rack-rewrite'
  s.add_dependency 'geocoder'
  
  s.add_dependency 'font-awesome-rails', '~> 4.2'
  s.add_dependency 'rails-assets-bootstrap-sass-official'
  s.add_dependency 'rails-assets-angular-bootstrap'
  s.add_dependency 'rails-assets-angular-strap'
  s.add_dependency 'rails-assets-angular-motion'
  s.add_dependency 'rails-assets-bootstrap-additions'
  s.add_dependency 'rails-assets-ngInfiniteScroll'
  s.add_dependency 'rails-assets-underscore'
  s.add_dependency 'rails-assets-underscore.string'
  s.add_dependency 'rails-assets-angularytics'
  s.add_dependency 'rails-assets-jasmine-sinon'
  s.add_dependency 'rails-assets-sinon'
  
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end
