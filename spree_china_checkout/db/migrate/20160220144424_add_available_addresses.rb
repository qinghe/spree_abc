class AddAvailableAddresses < ActiveRecord::Migration
  def change
    # use bill address only for china customer, disable ship address
    add_column :spree_stores, :available_addresses, :integer, :default=>0
  end


end
