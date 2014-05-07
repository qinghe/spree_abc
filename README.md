Welcome to SpreeABC
===================

Introduction goes here.
  SpreeABC is e-commerce solution based on spree.
  Difference is that you could create many websites, it is more like shopify and for china user.
  
Development  
===========
  install migrations
    rm db/migrate -Rf
    bundle exec rake railties:install:migrations
  
Deployment
==========
    bundle install --deloyment
    bundle exec rake db:reset RAILS_ENV=production
    bundle exec rake assets:precompile RAILS_ENV=production
  useful links:
  [A Capistrano Rails Guide]( https://gist.github.com/jrochkind/2161449 )

    iptables -A INPUT -p tcp -s 127.0.0.1 --dport 8080 -j ACCEPT
    sestatus -b | grep httpd
    togglesebool httpd_can_network_connection

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

Copyright (c) 2012 [david,hui], released under the New BSD License
