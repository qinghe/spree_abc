require 'rails_helper'

describe Spree::Admin::TemplateThemesController, :type => :controller do
  stub_authorization!
  stub_initialize_template!

  before(:each){
    @site2 = create(:site2)
    Spree::Site.current = create(:site1)
  }
  describe "demo #import theme from design" do

    let(:template_theme){ create(:importable_template_theme, store_id: @site2.stores.first.id  ) }
    it "responds successfully with an HTTP 200 status code" do
      spree_post :import, :id=> template_theme.id
      expect(response).to redirect_to( spree.foreign_admin_template_themes_path)
    end
  end
end
