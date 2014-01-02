attributes = {  
    :name =>  "Dalianshops designs",
    :domain => "design.dalianshops.com",
    :short_name => "design"
  }
site = Spree::Site.create!(attributes) 
   
Spree::Site.current = site

