class AddStoreWx < ActiveRecord::Migration
  # add feature store disignable
  def change
    add_column :spree_stores, :wx_appid, :string
    add_column :spree_stores, :wx_secret, :string
    add_column :spree_stores, :wx_token, :string
    #add_column :spree_stores, :wx_corpid, :string
  end
end
