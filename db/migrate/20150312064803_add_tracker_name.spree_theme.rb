# This migration comes from spree_theme (originally 20150312000001)
class AddTrackerName < ActiveRecord::Migration
    
  def change
    add_column :spree_trackers, :name, :string, :limit=>24
  end

end
