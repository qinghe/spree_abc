source 'http://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "capybara"
end

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end
gem 'spree', '1.1.1'
#gem 'spree_i18n',         :git => 'git://github.com/spree/spree_i18n.git'
#gem 'spree_multi_domain' #, :git => 'git://github.com/spree/spree-multi-domain.git'
gem 'spree_multi_site',   :path => '../spree_multi_site'

gem 'execjs'
gem 'therubyracer'
gem 'delayed_job_active_record'
