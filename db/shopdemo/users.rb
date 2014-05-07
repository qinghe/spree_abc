require 'highline/import'
# see last line where we create an admin if there is none, asking for email and password
password = 'spree123'
email = 'demo@dalianshops.com'
attributes = {
  :password => password,
  :password_confirmation => password,
  :email => email,
  :login => email
}

  admin = Spree::User.create(attributes)
  # create an admin role and and assign the admin user to that role
  role = Spree::Role.find_or_create_by_name 'admin'
  admin.spree_roles << role
  admin.save
