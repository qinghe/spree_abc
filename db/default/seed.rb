#encoding: utf-8
#Spree::Config.allow_ssl_in_production = false
files = [ "spree/countries", "spree/roles" ]
for file in files
  path = File.join(File.dirname(__FILE__), "#{file}.rb")
  puts "loading #{path}"
  load path
end

#load countries from spree_china_checkout

seed_path =  File.join(SpreeChinaCheckout::Engine.root,'db', 'seeds', 'countries.rb')
load seed_path
