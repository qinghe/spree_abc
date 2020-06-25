attributes = {
    :name =>  "Demo",
    :short_name => "demo",
    :email => "demo@example.com",
    :password =>'spree123'
  }
site = Spree::Site.create!(attributes)

Spree::Site.current = site

Spree::Site.current.stores.first.update_attribute(:is_public,true)
