attributes = {  
    :name =>  "Dalianshops demo",
    :domain => "demo.dalianshops.com",
    :short_name => "demo",
    :admin_email => "demo@dalianshops.com",
    :admin_password =>'spree123'
  }
site = Spree::Site.create!(attributes) 
   
Spree::Site.current = site

