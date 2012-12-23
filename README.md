Welcome to SpreeABC
===================

Introduction goes here.
  SpreeABC is e-commerce solution based on spree.
  Difference is that you could create many websites, it is more like shopify and for china user.
  
Development  
===========
reinstall all migration
-----------------------
rm db/migrate -Rf

bundle exec rake spree:install:migrations

bundle exec rake spree_promo:install:migrations

bundle exec rake spree_devise_auth:install:migrations

bundle exec rake spree_multi_site:install:migrations

bundle exec rake spree_china_checkout:install:migrations

bundle update spree_multi_site # update gem spree_multi_site

bundle update spree_alipay # update gem spree_alipay
  
Deployment
==========
bundle exec rake db:reset RAILS_ENV=production

bundle exec rake assets:precompile RAILS_ENV=production

#bundle exec rake jobs:work RAILS_ENV=production

iptables -A INPUT -p tcp -s 127.0.0.1 --dport 8080 -j ACCEPT

sestatus -b | grep httpd

togglesebool httpd_can_network_connection

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

Copyright (c) 2012 [david,hui], released under the New BSD License
