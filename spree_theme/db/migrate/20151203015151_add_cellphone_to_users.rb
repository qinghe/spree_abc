class AddCellphoneToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :cellphone, :string
    add_index :spree_users, :cellphone, unique: true
  end
end
