# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class AddDepthToPageLayouts < ActiveRecord::Migration
    
    def up
      if !Spree::PageLayout.column_names.include?('depth')
        add_column :spree_page_layouts, :depth, :integer
  
        say_with_time 'Update depth on all page_layout' do
          Spree::PageLayout.reset_column_information
          Spree::PageLayout.all.each { |t| t.save }
        end
      end
    end
  
    def down
      remove_column :spree_taxons, :depth
    end

end
