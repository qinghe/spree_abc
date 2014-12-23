# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class SupportMobile < ActiveRecord::Migration
  def change
    add_column :spree_sites, :support_mobile, :boolean, :null => false, :default => false    
    add_column :spree_template_themes, :for_mobile, :boolean, :null => false, :default => false    
    add_column :spree_sections, :for_mobile, :boolean, :null => false, :default => false    
    add_column :spree_section_pieces, :for_mobile, :boolean, :null => false, :default => false    
    add_column :spree_template_themes, :pc_theme_id, :integer, :null=>false, :default=>0    
  end
end
