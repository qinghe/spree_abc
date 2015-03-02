files = [ "sites", "template_text" ]
for file in files
  path = File.join(File.dirname(__FILE__), "#{file}.rb")
puts "loading #{path}"     
  load path
end

