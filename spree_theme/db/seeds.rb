#  
# rake RAILS_ENV=test db:seed
include SpreeTheme::SeedHelper
# plese load section_pieces first, seed sections.rb need it.

seeds_path = File.join(File.dirname(__FILE__), 'seeds')
#suffix number of seeds file name indicate loading order. 
xpath = File.join(seeds_path, "*.rb")
Dir[xpath].sort.each {|file| 
  puts "loading #{file}"
  load file
}

#if ENV['DISABLE_EXTRA_PARAMS'].blank?
#  seeds_path = File.join(File.dirname(__FILE__), 'extra_piece_params')
#  xpath = File.join(seeds_path, "*.rb")
#  Dir[xpath].sort.each {|file| 
#    puts "loading #{file}"
#    load file
#  }
#end
###################################################################################################################################################################################################################################################################################################################################################################################   
# Section

puts "loading spree_theme seeds complete!"

