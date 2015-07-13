attributes = {  
    :name =>  "Dalianshops demo",
    :domain => "demo.dalianshops.com",
    :short_name => "demo"
  }
site = Spree::Site.create!(attributes) 
   
Spree::Site.current = site

