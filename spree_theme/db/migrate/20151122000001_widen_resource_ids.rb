class WidenResourceIds < ActiveRecord::Migration
  def change
    change_column :spree_template_themes, :assigned_resource_ids , :string, :limit => 2048, :null => false, :default => ''
  end
end
