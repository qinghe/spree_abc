require 'rails_helper'
describe Spree::SitesController do
  stub_initialize_template!

  context "with host nonexistent" do
    before do
      @site1 = create(:site1)
    end

    it "should response moved_permanently" do
      request.host = 'nonexistent' # it is localhost
      spree_get :one_click_trial
      expect(response).to have_http_status(:moved_permanently)
    end
  end
end

describe Spree::PageLayoutsController do
  stub_initialize_template!

  context "with host nonexistent" do
    let( :template_theme ){ create( :template_theme) }
    let( :page_layout ){ create( :page_layout) }
    before do
      Spree::Site.current = create(:site1)
    end
    it "should response moved_permanently" do
      request.host = 'nonexistent' # it is localhost
      spree_get :edit,:template_theme_id => template_theme.id, :id => page_layout.id
      expect(response).to have_http_status(:moved_permanently)
    end
  end
end
