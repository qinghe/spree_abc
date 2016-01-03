RSpec.configure do |config|
  config.include Devise::TestHelpers,   type: :controller
  config.include Rack::Test::Methods,   type: :feature
end
