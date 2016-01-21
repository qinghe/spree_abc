# This migration comes from spree_multi_site (originally 20160117045742)
class AddSiteStatus < ActiveRecord::Migration
  # add feature store disignable
  def change
    add_column :spree_sites, :status, :integer, default: 0
  end
end
