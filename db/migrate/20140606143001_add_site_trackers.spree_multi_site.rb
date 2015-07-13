# This migration comes from spree_multi_site (originally 20140606045742)
class AddSiteTrackers < ActiveRecord::Migration
  # in this file add site_id after all table complete. 
  def up   
    add_column :spree_trackers, :site_id, :integer          
  end

  def down
    remove_column :spree_trackers, :site_id
  end
end
