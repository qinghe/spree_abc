attributes = {  
    :name =>  "Dalian shops",
    :domain => "www.dalianshops.com",
    :short_name => "firstshop"
  }
Spree::Site.create!(attributes)    
Spree::Site.current = Spree::Site.first

# see last line where we create an admin if there is none, asking for email and password
=begin
def create_site
  
  name = 'Abc'
  domain = Spree::Site.abc_domain    
  
  attributes = {
    :name => name,
    :domain => domain
  }

  load 'spree/site.rb'

  if Spree::Site.find_by_domain(domain)
    say "\nWARNING: There is already a site with the domain: #{domain}, so no site changes were made.  If you wish to create an additional site, please run rake db:site:create again with a different domain.\n\n"
  else
    admin = Spree::Site.create!(attributes)    
  end
end

if Spree::Site.admin.blank?
  create_site
  #creating user require it.
  Spree::Site.current =Spree::Site.admin 
else
  puts "Default site #{domain} has already been previously created."
end
=end
