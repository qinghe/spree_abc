class AddForeignThemeId < ActiveRecord::Migration
  # in this file add site_id after all table complete.
  def change
    # customer could select a theme when creating site.
    if ActiveRecord::Base.connection.table_exists? 'spree_sites'
      add_column :spree_sites, :foreign_theme_id, :integer, :null=>false, :default=>0
    else
      add_column :spree_fake_websites, :foreign_theme_id, :integer, :null=>false, :default=>0          
    end
  end

end
