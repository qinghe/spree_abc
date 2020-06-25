class AddStoreDesignable < ActiveRecord::Migration
  # add feature store disignable
  def change
    add_column :spree_stores, :designable, :boolean, default: false
    SpreeTheme.site_class.where(:short_name=>['design','design2','design1']).each{|site|
      site.stores.first.update_attribute :designable, true
    }
  end
end
