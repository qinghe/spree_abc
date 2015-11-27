require 'test_helper'

class Spree::Admin::PostFilesIntegrationTest < SpreeEssentials::IntegrationCase

  setup do
    Spree::PostFile.destroy_all
    @post = Spree::Post.first || Factory.create(:spree_post)
  end
  
  should "have a link to new post image" do
    visit spree.admin_post_files_path(@post)
    btn = find("#new_image_link").native
    assert_match /#{spree.new_admin_post_file_path(@post)}$/, btn.attribute('href')
    assert_equal "New Image", btn.text
  end
  
  should "get new post image" do  
    visit spree.new_admin_post_file_path(@post)
    assert_seen "New Image"
    within "#new_post_file" do
      assert has_field?("Attachment")
      assert has_field?("Alt")   
    end
  end
  
  should "validate post image" do
    visit spree.new_admin_post_file_path(@post)
    click_button "Create"
    within "#errorExplanation" do
      assert_seen "2 errors prohibited this record from being saved:"
      assert_seen "Attachment can't be empty"
      assert_seen "Attachment file name can't be empty"
    end
  end
  
  should "create post image" do
    visit spree.admin_post_files_path(@post)
    click_link "New Image"
    within "#new_post_file" do
      attach_file "Attachment", sample_image_path
      fill_in "Alt", :with => "alt text!"
    end
    click_button "Create"
    assert_equal spree.admin_post_files_path(@post), current_path
    assert_flash :notice, "Post image has been successfully created!"
  end
  
  context "existing post image" do    
    setup do
      @post_file = Factory.create(:spree_post_file, :viewable => @post)
    end
    
    should "edit and update" do
      visit spree.edit_admin_post_file_path(@post, @post_file)      
      within "#edit_post_file_#{@post_file.id}" do
        attach_file "Attachment", sample_image_path("2.jpg")
        fill_in "Alt", :with => "omg!"
      end
      click_button "Update"
      assert_equal spree.admin_post_files_path(@post), current_path
      assert_flash :notice, "Post image has been successfully updated!"
    end
    
    should "get destroyed" do
      visit spree.admin_post_files_path(@post)
      within "table.index" do
        find("a[href='#']").click
      end
      assert find_by_id("popup_ok").click
    end
    
  end
  
  context "several post images" do
  
    setup do
      setup_action_controller_behaviour(Spree::Blogs::Admin::PostFilesController)
      @post_files = Array.new(2) {|i| Factory(:spree_post_file, :alt => "Image ##{i + 1}", :viewable => @post, :position => i) }
    end
    
    should "update positions" do
      positions = Hash[@post_files.map{|i| [i.id, 2 - i.position ]}]
      visit spree.admin_post_files_path(@post)
      assert_seen "Image #1", :within => "tbody tr:first"
      assert_seen "Image #2", :within => "tbody tr:last"
      xhr :post, :update_positions, { :post_id => @post.to_param, :positions => positions }
      visit spree.admin_post_files_path(@post)      
      assert_seen "Image #2", :within => "tbody tr:first"
      assert_seen "Image #1", :within => "tbody tr:last"
    end
  
  end
  
end
