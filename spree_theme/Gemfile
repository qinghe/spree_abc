source 'http://rubygems.org'



gem 'spree', :github => "spree/spree", :branch => "2-0-stable"

group :test,:development do
  gem 'ruby-graphviz' #print checkout flow
  gem 'simplecov' #rspec using it.
  #using backend required
  gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '2-0-stable'
  gem "mysql2"
  gem 'thin'
end

#group :test do
#  gem 'ffaker'
#end

gem "acts_as_list"
gem "acts_as_tree"
gem "awesome_nested_set"

#use paperclip instead of dragonfly,  dragonfly have no way to configure image path
#gem "paperclip", "2.8.0" # spree require it.
gem "responds_to_parent"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "friendly_id"

group :assets do
  gem 'sass'
  gem 'coffee-rails'
end
#gem 'ssl_requirement'
gemspec
