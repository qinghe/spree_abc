#suffix number of seeds file name indicate loading order. 
xpath = File.join(File.dirname(__FILE__), "*.rb")
Dir[xpath].sort.each {|file| 
  next if file=~/seed.rb$/
  puts "loading #{file}"
  load file
}