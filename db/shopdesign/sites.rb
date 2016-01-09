attributes = {
    :name =>  "Getstore Design",
    :domain => "design.getstore.cn",
    :short_name => "design",
    :email => 'design@getstore.cn',
    :password => 'spree123'
  }
site = Spree::Site.create!(attributes)

Spree::Site.current = site

Spree::Site.current.stores.first.update_attribute(:is_public,true)
