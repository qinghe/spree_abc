#encoding: utf-8
#Spree::Config.allow_ssl_in_production = false
files = [ "spree/countries", "spree/roles" ]
for file in files
  path = File.join(File.dirname(__FILE__), "#{file}.rb")
  puts "loading #{path}"     
  load path
end