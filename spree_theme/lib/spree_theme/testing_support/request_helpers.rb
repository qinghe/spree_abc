# when test controller admin/*,  initialize_template should be ignored
# in rspec, request_fullpath = /?action=apply
# request.fullpath not start with /admin
module SpreeTheme
  module TestingSupport
    module RequestHelpers
      module Request
        def stub_initialize_template!
          before(:each) {
            #refer to spree/core/store
            Spree::Store.current(  create(:store).url )
            allow(controller).to receive(:initialize_template).and_return(nil)
          }
        end

        def stub_spree_user!
          before(:each) {
            user = mock_model(Spree.user_class, :last_incomplete_spree_order => nil, :spree_api_key => 'fake')
            allow(controller).to receive_messages :spree_current_user => user
          }
        end

      end
    end
  end
end
RSpec.configure do |config|
  config.extend SpreeTheme::TestingSupport::RequestHelpers::Request, type: :controller
end
