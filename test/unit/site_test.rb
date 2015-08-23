#encoding: utf-8
require 'test_helper'
class SiteTest < ActiveSupport::TestCase
  setup do
    @site = Spree::Site.new(:name=>'ABCD',:domain=>'www.abc.net', :email=>'test@dalianshops.com', :password=>'123456')
  end


  test "load samples" do
    @site.save!
    Spree::Site.current = @site
    @site.load_sample
    @site.reload
    assert @site.shipping_categories.present?
    product = @site.products.first
    assert product.shipping_category.present?, 'product has shipping category'
    assert product.tax_category.present?, 'product has tax category'
  end


  test "remove samples" do
    @site.save!
    @site.load_sample
    @site.reload
    @site.unload_sample
    Spree::Site.current = @site
    assert_equal Spree::Product.count,0
    assert_equal Spree::Variant.count,0
    assert_equal Spree::PaymentMethod.count,0
    assert_equal Spree::TaxCategories.count,0
    assert_equal Spree::Zone.count, 0
    assert_equal Spree::StateChange.count, 0
    #product variants
    #taxonomy, taxon
    #zone,zone_member
    #state_changes
  end

  #test "create two site and load samples for them" do
  #  @site1 = Spree::Site.create!(:name=>'Site1',:domain=>'www.site1.net',:short_name=>'site1')
  #  @site2 = Spree::Site.create!(:name=>'Site1',:domain=>'www.site2.net',:short_name=>'site2')
  #  @site1.load_sample
  #  @site2.load_sample
  #  #product image copied and in right folder.
  #end

end
