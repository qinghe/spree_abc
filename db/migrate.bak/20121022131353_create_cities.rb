class CreateCities < ActiveRecord::Migration
  def up
    create_table :spree_cities do |t|
      t.string   :name
      t.string   :abbr
      t.references :state
    end
    add_column 'spree_addresses', :city_id, :integer, :default=>0
    add_column 'spree_addresses', :city_name, :string
    
  end

  def down
    drop_table :spree_cities
    remove_column 'spree_addresses', :city_id
    remove_column 'spree_addresses', :city_name
  end
end
