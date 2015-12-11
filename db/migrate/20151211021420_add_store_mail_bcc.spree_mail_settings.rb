# This migration comes from spree_multi_site (originally 20151211045742)
class AddStoreMailBcc < ActiveRecord::Migration
  # in this file add site_id after all table complete.
  def up
    add_column :spree_stores, :mail_bcc, :string
  end

  def down
    remove_column :spree_stores, :mail_bcc
  end
end
