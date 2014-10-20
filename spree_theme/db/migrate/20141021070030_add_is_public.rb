# some section piece is clickable, like taxon name, product name, post name, 
# in some case, we don't want it to be clickable, ex. in product detail page, product name should not be clickable. 
class AddIsClickable < ActiveRecord::Migration
  def change
    # is this theme public to other site
    add_column :spree_template_themes, :is_public, :boolean, :null => false, :default => false

  end

end
