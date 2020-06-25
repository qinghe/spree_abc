# Be sure to restart your server when you modify this file.

# we should disable domain: :all,
# fix case: after loggin design.getstore.cn/admin,  open new tab getstore.cn,
# then the design.getstore.cn/admin become unauthenticate
SpreeAbc::Application.config.session_store :active_record_store, key: '_GetStore_3_0' #, domain: :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# SpreeAbc::Application.config.session_store :active_record_store
