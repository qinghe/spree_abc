class AddSiteToSpreeRelationTypes < ActiveRecord::Migration
  def change
    add_column :spree_relation_types, :site_id, :integer
  end
end
