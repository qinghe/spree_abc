SpreeMultiSite
==============

Introduction goes here.
  # set site sample_path, default is Rails.application.root/db/sample
  # copy it into config/initializers/spree.rb
  Spree::Site.sample_path = File.join(Rails.application.root, "db", 'sample')  
  # url for site admin 
  http://localhost:3000/admin/sites
  
  # create new site 
  http://localhost:3000/new_site
  
  # it is using delayed_job to load sample when create site vie above url
  # Start a delayed_job worker.
  rake jobs:work  
  want more about delayed_job, please go to https://github.com/collectiveidea/delayed_job
  
  # a site load the sample data in console 
  $> rails r "Spree::Site.first.load_sample"
  
  # a site remove sample data in console 
  $> rails r "Spree::Site.first.load_sample(false)"
  
  # login shop by localhost for test
  please set cookies key :abc_development_domain=your-site-domain.
  
Example
=======

Example goes here.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test app
    $ bundle exec rspec spec

    # if you delete all migrations in db/migrate, try all belows to recovery
    rake spree:install:migrations                          # copy migrations from spree_core
    rake spree_api:install:migrations                      # Copy migrations from spree_api to application
    rake spree_auth:install:migrations                     # Copy migrations from spree_auth to application
    rake spree_promo:install:migrations      
    rake spree_multi_site:install:migrations               # Copy migrations from spree_multi_site to applica...
    # load default data, no sample
    $ bundle rake db:reset
    
After load default&first seeds, you could test manually by providing those parameters or cookies,
    params[:n]: n is 'short_name.dalianshops.com'
    cookies[:abc_development_short_name]: abc_development_short_name is site's short_name     

Todos
=======
fix db index, add site_id into index  
    
Copyright (c) 2012 [david,hui], released under the New BSD License
