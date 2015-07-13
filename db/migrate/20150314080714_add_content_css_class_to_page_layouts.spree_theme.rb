# This migration comes from spree_theme (originally 20150314000001)
class AddContentCssClassToPageLayouts < ActiveRecord::Migration
    
  def change
    # support bootstrap css class 
    add_column :spree_page_layouts, :content_css_class, :string
  end

end
