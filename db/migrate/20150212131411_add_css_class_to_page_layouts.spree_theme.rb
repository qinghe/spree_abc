# This migration comes from spree_theme (originally 20150210000030)
class AddCssClassToPageLayouts < ActiveRecord::Migration
    
  def change
    # support bootstrap css class 
    add_column :spree_page_layouts, :css_class, :string
  end

end
