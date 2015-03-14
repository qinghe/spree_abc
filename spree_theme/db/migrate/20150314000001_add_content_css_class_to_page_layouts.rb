class AddContentCssClassToPageLayouts < ActiveRecord::Migration
    
  def change
    # support bootstrap css class 
    add_column :spree_page_layouts, :content_css_class, :string
  end

end
