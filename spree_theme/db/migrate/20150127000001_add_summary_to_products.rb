# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class AddSummaryToProducts < ActiveRecord::Migration      
    def change
      add_column :spree_products, :summary, :string #ad
    end
end
