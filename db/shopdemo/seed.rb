files = [ "sites", "users", "products"]
for file in files
  path = File.join(File.dirname(__FILE__), "#{file}.rb")
Rails.logger.debug "start load #{file}"     
  load path
end
