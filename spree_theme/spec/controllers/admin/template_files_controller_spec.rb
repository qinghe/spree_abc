require "spec_helper"

describe Spree::Admin::TemplateFilesController, :type => :controller do
  stub_authorization!

  describe "GET #native" do
    it "responds successfully with an HTTP 200 status code" do
      spree_get :index
      expect(response).to be_success
      expect(response).to render_template("index")
    end
  end

end
