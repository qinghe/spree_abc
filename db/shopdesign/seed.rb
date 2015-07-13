files = [ "sites", "users", "products"]
for file in files
  path = File.join(File.dirname(__FILE__), "#{file}.rb")
  puts "loading #{file}"     
  load path
end

load File.join(SpreeTheme::Engine.root,'db/themes/seed.rb')
