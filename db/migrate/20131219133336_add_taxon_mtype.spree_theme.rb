# This migration comes from spree_theme (originally 20131129070030)
class AddTaxonMtype < ActiveRecord::Migration
  def up
    add_column :spree_taxons, :page_context, :integer,   :null => false, :default => 0
    # 1:home, 2:cart, 3:checkout, 4:thanks, 5:signup, 6:login, 7:account, 
  end

  def down
    remove_column :spree_taxons, :page_context      
  end
end
