source 'http://ruby.taobao.org'
#source 'http://rubygems.org'
gem 'rails', '3.2.8'
gem 'mysql2'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0.3'
end
#==================required rails===================

gem 'jquery-rails'
gem 'spree', '1.2.0'

group :test do
  gem 'ffaker'
  gem 'sqlite3'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gem 'daemons' #require it while running script/delayed_job.
gem 'delayed_job_active_record'

group :development,:test do
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
end

gemspec

#start server for test
#rails s -p3002 -etest
