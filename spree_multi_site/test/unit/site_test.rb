require File.dirname(__FILE__) + '/../test_helper'
 
class SiteTest < Test::Unit::TestCase
  context "models should has default scope" do
    #model.new should have current site id  
    
  end
  
	context "A site hierarchy" do
		setup do
			@parent = Factory.create(:site)
			@site = Factory.create(:site )
			@child1 = Factory.create(:site )
			@child2 = Factory.create(:site )
			@leaf = Factory.create(:site )
			
			# NOTE: these have to be built from the bottom up!
			@leaf.move_to_child_of @child1
			@child1.move_to_child_of @site
			@child2.move_to_child_of @site
			@site.move_to_child_of @parent
		end
		
		should "load awesome_nested_set" do
			assert CollectiveIdea::Acts::NestedSet
		end
		
		should "be an awesome_nested_set" do
			assert_not_nil @parent.root
			assert @parent.valid?
		end
		
		should "return site values" do
			assert @site.name
			assert @site.domain
		end
		
		should "return the parent site" do
			assert_equal( @parent, @site.parent )
		end
		
		should "return the child sites" do
			assert @site.children.all.include? @child1
			assert @site.children.all.include? @child2
		end
		
		should "gather its ancestors with 'self_and_ancestors'" do
			assert_contains( @site.self_and_ancestors, @site )
			assert_contains( @site.self_and_ancestors, @parent )
		end
		
		should "gather its siblings with 'self_and_siblings'" do
			assert_contains( @child1.self_and_siblings, @child1 )
			assert_contains( @child1.self_and_siblings, @child2 )
		end
		
		should "gather its descendants with 'self_and_descendants'" do
			assert_contains( @site.self_and_descendants, @site )
			assert_contains( @site.self_and_descendants, @child1 )
		end
		
		should "show the correct root element" do
			assert_equal( @parent, @site.root )
		end
		
		should "not include parents in 'self_and_descendants'" do
			assert !( @site.self_and_descendants.include? @parent )
		end
	end
end