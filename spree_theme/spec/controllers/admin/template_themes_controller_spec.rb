require "spec_helper"

describe Spree::Admin::TemplateThemesController, :type => :controller do
  stub_authorization!
  #stub_initialize_template!

  let(:template_theme) do
    create(:template_theme)
  end

  describe "GET #native" do

    context 'with none template themes' do
      it "responds successfully with an HTTP 200 status code" do
        spree_get :native
        expect(response).to be_success
        expect(response).to render_template("native")
      end
    end
  end

    context 'apply theme to store' do
      before(:each) do
        Spree::Store.current(  create(:store)  )
      end

      it "responds successfully with an HTTP 200 status code" do
        spree_xhr_post :apply, :id=>template_theme.id
        expect(response).to be_success
        #expect(response).to render_template("native")
      end
    end


end
