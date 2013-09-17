###################################################################################################################################################################################################################################################################################################################################################################################   
#suffix number of seeds file name indicate loading order. 
Spree::Site.current = Spree::Site.first

xpath = File.dirname(__FILE__)+ "/*.rb"
Dir[xpath].sort.each {|file| 
  next if file=~/seed.rb/
  puts "loading #{file}"
  load file
}

Spree::Site.current.theme_id = Spree::TemplateTheme.within_site( Spree::Site.current ).first.id
Spree::Site.current.save! 
puts "loading templates complete!"
