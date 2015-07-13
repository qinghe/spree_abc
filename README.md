Welcome to SpreeABC
===================

Introduction goes here.
  SpreeABC is e-commerce solution based on spree.
  Difference is that you could create many websites, it is more like shopify and for china user.
  __It is working in progress__.

Project structure
=================
external gems
-------------
* spree - basic e-commerce solution
* spree_editor - rich text editor with file uploading in-place
* spree_alipay - payment method alipay
internal gems
-------------
* spree_essential_blog - support articles
* spree_flexi_variants - create product variants as-needed, option value has image.
* spree_comments - comments to product/article
* spree_multi_site  - support multiple separated website
* spree_theme - frontend template system
* spree_china_checkout - improve checkout flow for china user.

Development  
===========
    rake db:create
    rake db:migrate
    rake db:seed


Deployment
==========
     bundle install --deloyment
     bundle exec rake db:reset RAILS_ENV=production
     bundle exec rake assets:precompile RAILS_ENV=production
  Helpful links for deployment
  ----------------------------

  Helpful command for deployent
  ----------------------------
    bundle exec rake railties:install:migrations
    iptables -A INPUT -p tcp -s 127.0.0.1 --dport 8080 -j ACCEPT
    sestatus -b | grep httpd
    togglesebool httpd_can_network_connection

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

Copyright (c) 2012 [david,hui], released under the New BSD License
