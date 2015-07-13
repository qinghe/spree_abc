require "spec_helper"

describe Spree::Admin::TemplateThemesController, :type => :controller do
  stub_authorization!

  describe "GET #native" do
    it "responds successfully with an HTTP 200 status code" do
      spree_get :native
      expect(response).to be_success
      expect(response).to render_template("native")
    end   
  end

  describe "post #apply" do
    it "responds successfully with an HTTP 200 status code" do
      spree_post :apply, :id=>Spree::TemplateTheme.first
      expect(response).to be_success
      expect(response).to render_template("native")
    end   
  end

  describe "demo #import theme from design" do
    it "responds successfully with an HTTP 200 status code" do
      spree_post :import, :id=>Spree::TemplateTheme.first, :assigned_resource_ids=>{}, :template_files=>[]
      expect(response).to be_success
      expect(response).to render_template("foreign")
    end   
  end
end