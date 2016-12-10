# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class AddIsClickable < ActiveRecord::Migration
  def change
    add_column :spree_section_pieces, :is_clickable, :boolean, :null => false, :default => false
    add_column :spree_sections, :content_param, :integer, :null => false, :default => 0
    
    add_column :spree_page_layouts, :content_param, :integer, :null => false, :default => 0
    # for section taxon_name, product_name, product_image.  bit 1 indicate clickable.
    # for section image_with_thumbnails, 
    #                                                      2         4            6   
    #   bit 2,3,4 indicate main_image size,  00: product, 01:large, 10: original, 11:small
    #                                                     16        32            48   
    #   bit 5,6,7 indicate thumbnail size    00: small,   01:large, 10: original, 11:product
    # for section menu, bit 3,4 indicate 'hover effect'
    #   bit 3 two menu item exchange on hover                                    
  end

end
