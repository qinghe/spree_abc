class AddCssClassToPageLayouts < ActiveRecord::Migration
    
  def change
    # support bootstrap css class 
    add_column :spree_page_layouts, :css_class, :string
  end

end
