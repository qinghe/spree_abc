require 'highline/import'
# see last line where we create an admin if there is none, asking for email and password
password = 'spree123'
email = 'design@dalianshops.com'
attributes = {
  :password => password,
  :password_confirmation => password,
  :email => email,
  :login => email
}

load 'spree/user.rb'

if Spree::User.find_by_email(email)
  say "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create an additional admin user, please run rake db:admin:create again with a different email.\n\n"
else
  admin = Spree::User.create(attributes)
  # create an admin role and and assign the admin user to that role
  role = Spree::Role.find_or_create_by(name: 'admin')
  admin.spree_roles << role
  admin.save
end
