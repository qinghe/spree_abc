attributes = {  
    :name =>  "Dalianshops design",
    :domain => "design.dalianshops.com",
    :short_name => "design",
    :admin_email => 'design@dalianshops.com',
    :admin_password => 'spree123'
  }
site = Spree::Site.create!(attributes) 
   
Spree::Site.current = site

