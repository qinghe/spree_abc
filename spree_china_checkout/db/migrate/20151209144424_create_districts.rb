class CreateDistricts < ActiveRecord::Migration
  def up
    create_table :spree_districts do |t|
      t.string   :name
      t.string   :abbr
      t.references :city
    end
    add_column 'spree_addresses', :district_id, :integer, :default=>0

  end

  def down
    drop_table :spree_districts
    remove_column 'spree_addresses', :district_id
  end
end
