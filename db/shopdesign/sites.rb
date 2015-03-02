attributes = {  
    :name =>  "Dalianshops design",
    :domain => "design.dalianshops.com",
    :short_name => "design",
    :email => 'design@dalianshops.com',
    :password => 'spree123'
  }
site = Spree::Site.create!(attributes) 
   
Spree::Site.current = site

