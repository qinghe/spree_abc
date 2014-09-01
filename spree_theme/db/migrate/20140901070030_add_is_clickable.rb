# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class AddIsClickable < ActiveRecord::Migration
  def change
    add_column :spree_section_pieces, :is_clickable, :boolean, :null => false, :default => false
    add_column :spree_sections, :content_param, :integer, :null => false, :default => 0
    add_column :spree_page_layouts, :content_param, :integer, :null => false, :default => 0
    #set section to be clickable.  bit 1 indicate clickable. 
  end

end
