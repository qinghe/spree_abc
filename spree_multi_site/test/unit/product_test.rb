require File.dirname(__FILE__) + '/../test_helper'
 
class SiteTest < Test::Unit::TestCase

	context "A product in a site hierarchy" do
		setup do
			@base = Factory.create(:site)
			@branch1 = Factory.create(:site)
			@branch2 = Factory.create(:site)
			@leaf = Factory.create(:site)
			
			@branch1.move_to_child_of @base
			@branch2.move_to_child_of @base
			@leaf.move_to_child_of @branch1
			
			@product = Factory.create(:product, :site => @branch1)
		end
		
		should "return product values" do
			assert @product.name
			assert @product.price
		end
		
		should "have an associated site" do
			assert_equal( @branch1, @product.site )
		end
		
		should "show up in the local list of products from the associated site" do
			assert Product.by_site( @branch1 ).all.include? @product
		end
		
		should "show up in the full list of products from the parent site" do
			assert Product.by_site_with_descendants( @base ).all.include? @product
		end
		
		should "not show up in either list of products from a leaf site" do
			assert  !Product.by_site( @leaf ).all.include?( @product)
			assert  !Product.by_site_with_descendants( @leaf ).all.include?( @product)
		end
		
		should "not show up in either list of products from adjacent branch sites" do
			assert  !Product.by_site( @branch2 ).all.include?( @product)
			assert  !Product.by_site_with_descendants( @branch2 ).all.include?( @product)
		end
	end
end