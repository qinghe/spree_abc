class AddForeignThemeId < ActiveRecord::Migration
  # in this file add site_id after all table complete. 
  def change   
    add_column :spree_sites, :foreign_theme_id, :integer, :null=>false, :default=>0          
  end

end
