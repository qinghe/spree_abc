require 'rails_helper'
describe Spree::SitesController do
  stub_initialize_template!

  context "with host nonexistent" do
    before do
      #@site1 = create(:site1)
      #@site2 = create(:site2)
    end

    it "should response moved_permanently" do
      request.host = 'nonexistent' # it is localhost
      spree_get :one_click_trial
      expect(response).to have_http_status(:moved_permanently)
    end
  end
end
