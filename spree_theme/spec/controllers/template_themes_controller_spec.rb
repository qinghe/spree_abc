require "spec_helper"

describe Spree::TemplateThemesController, :type => :controller do
  describe "GET #index" do
    #FIXME test it
    it "get upload image dialog" do
      param_value = Spree::ParamValue.first
      spree_xhr_get :upload_file_dialog,{:param_value_id=>param_value.id,:html_attribute_id=>param_value.html_attribute_ids.first}
      expect(response).to be_success
      assigns(:param_value).should eq(param_value)      
    end
    
    it "post upload template image" do
      file = fixture_file_upload("/favicon.ico", 'image/ico')
      xhr :post, :upload_file_dialog,{:param_value_id=>param_value.id,:html_attribute_id=>param_value.html_attribute_ids.first,
        :template_file => {"attachment"=> file}
        }
      expect(response).to be_success
    end
    
  end
end