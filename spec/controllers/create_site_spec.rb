require 'rails_helper'

describe Spree::SitesController, :type => :controller do

  before(:all) do
    Spree::Site.current = create(:site1)
    #load  File.join( Rails.root, 'spree_theme', 'db', 'themes', 'first', 'site_form.rb')
    # for unkonwn reason, is_public is false, we set it here
    #Spree::Store.current.update_attributes( theme_id: Spree::TemplateTheme.first.id, is_public: true )
  end

  let( :new_site_params ) {
    { site:
      { name: 'a unique store',
        password: '666666',
        email: 'unknown@getstore.cn'
      }
    }
  }

  context "site without template" do
    stub_initialize_template!

    it "create site successfully" do
      #get '/'
      #assert_select "form.site_form" do
      #    assert_select('#site_name', 'a unique store' )
      #    assert_select('#site_email', 'unknown@getstore.cn' )
      #    assert_select('#site_password', 'spree123' )
      #end
      spree_post "create", new_site_params

      assert assigns(:site)

      assert_redirected_to assigns(:site).admin_url

    end
  end

  context "site with template" do
    stub_initialize_template!

    let!( :template_theme ){ create( :importable_template_theme )}

    it "create site and template successfully" do
      #get '/'
      #assert_select "form.site_form" do
      #    assert_select('#site_name', 'a unique store' )
      #    assert_select('#site_email', 'unknown@getstore.cn' )
      #    assert_select('#site_password', 'spree123' )
      #end
      new_site_params[:site][:foreign_theme_id] = template_theme.id
      spree_post "create", new_site_params
      site = assigns(:site)
      assert site
      expect( site.foreign_template_theme ).to be_kind_of Spree::TemplateTheme
      assert_redirected_to assigns(:site).admin_url

    end
  end
end
