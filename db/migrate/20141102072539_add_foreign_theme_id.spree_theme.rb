# This migration comes from spree_multi_site (originally 20141102045742)
class AddForeignThemeId < ActiveRecord::Migration
  # in this file add site_id after all table complete. 
  def change   
    add_column :spree_sites, :foreign_theme_id, :integer, :null=>false, :default=>0          
  end

end
