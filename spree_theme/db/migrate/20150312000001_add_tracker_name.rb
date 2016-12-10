class AddTrackerName < ActiveRecord::Migration
    
  def change
    add_column :spree_trackers, :name, :string, :limit=>24
  end

end
