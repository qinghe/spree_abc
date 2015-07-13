# This migration comes from spree_theme (originally 20141026070030)
class AssociateThemeToProduct < ActiveRecord::Migration
  def change
    # associate product to a template theme
    add_column :spree_products, :theme_id, :integer, :null => false, :default => 0

  end

end
