# when test controller admin/*,  initialize_template should be ignored
# in rspec, request_fullpath = /?action=apply
# request.fullpath not start with /admin
module SpreeTheme
  module TestingSupport
    module RequestHelpers
      module Request
        def stub_initialize_template!
          before(:each) {
            allow(controller).to receive(:initialize_template).and_return(nil)
          }
        end
      end
    end
  end
end
RSpec.configure do |config|
  config.extend SpreeTheme::TestingSupport::RequestHelpers::Request, type: :controller
end
