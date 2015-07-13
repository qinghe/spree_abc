#SpreeTheme

New frontend of spree, user could easy modify theme or add new theme.
__It is just for spree_abc, not common use, cause it override some cart/checkout views.__

####terms and conditions
Each site want their own theme, site could have more than one themes.
Theme should be configurable, site could assigned their own data to it.
Each site could select preferred theme from all available list.
Designer could design theme and release it.

Shops
* design shop: product is theme, designer produce theme on line.
* other shop: use released theme as frentend, sell product on line.
__a design/shopping site must have a released theme, or redirect to under_contruction.__

Roles
* user:  on line shop user, have full permission to manage shop.
* customer: shopping on line.
* designer: login design site, design template on line.

Themes
* theme: a theme of site, contains html, js, css.


####How it work
designer produce theme
  0. in design shop, create new theme.
  1. design theme vie editor.
  2. release completed theme, generate theme files themeX/html, css, js
  3. theme is public now. user could import, config and publish.

user apply theme to site
  1. user browse available themes, snapshot or live demo.
  2. import preferred theme,
  3. configure it with site data.
  4. apply it as frontend

####Installation(tbd...)
rake spree_theme:install:migrations
rake db:migrate
rails r "SpreeeTheme::Engine.load_seed"
in config/spree.rb
SpreeTheme.website_class = 'Spree::FakeWebsite'
SpreeTheme.taxon_class = 'Spree::Taxon'

Load sample

rake spree_theme:load_samples
rake spree_theme:import_theme

####Testing(tbd...)
rake test_app

change db from sqlite to mysql,  fix id setting, rails sqlite adapter ignore id setting  
rake db:seed RAILS_ENV=test
rake spree_theme:import_theme  RAILS_ENV=test  SEED_PATH=1 THEME_ID=2


Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 [ruanshan], released under the New BSD License
