# This migration comes from spree_multi_site (originally 20120818045742)
class AddSitePaymentMethods < ActiveRecord::Migration
  # in this file add site_id after all table complete. 
  def up
    table_name = Spree::PaymentMethod.connection.table_exists?(:payment_methods) ? :payment_methods : :spree_payment_methods
    add_column table_name, :site_id, :integer
  end

  def down
     remove_column Spree::PaymentMethod.table_name, :site_id
  end
end
