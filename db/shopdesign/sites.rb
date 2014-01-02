attributes = {  
    :name =>  "Dalian shops designs",
    :domain => "design.dalianshops.com",
    :short_name => "designshop"
  }
site = Spree::Site.create!(attributes) 
   
Spree::Site.current = site

