require "spec_helper"

describe Spree::TemplateThemesController, :type => :controller do
  stub_initialize_template!
  context "template editor" do
    let(:param_value) { create(:updatable_param_value) }
    let(:background_image) { create(:background_image) }
    before(:each) {
      allow( param_value).to receive(:html_attribute_ids).and_return( [1,2] )
    }
    #FIXME test it
    it "get upload image dialog" do

      xhr_get :upload_file_dialog,{:id=> param_value.theme_id, :param_value_id=>param_value.id,:html_attribute_id=> background_image.id }
      expect(response).to be_success
      assigns(:param_value).should eq(param_value)
    end

    it "post upload template image" do
      file = fixture_file_upload("qinghe.jpg", 'image/jpg')
      xhr_post :upload_file_dialog, {:id=> param_value.theme_id,  :param_value_id=>param_value.id,:html_attribute_id=> background_image.id,
        :template_file => {"attachment"=> file}
        }
      expect(response).to be_success
    end
  end

  context "designable store " do
    before(:each) {
      create(:store, default: true, designable: true)
      allow( controller ).to receive(:get_layout_if_use).and_return( false )
    }

    it "preview "  do
      spree_get :preview
      expect(response).to be_success
    end
  end

  it "should not previewable vie nondesignable store"  do
  end

end
