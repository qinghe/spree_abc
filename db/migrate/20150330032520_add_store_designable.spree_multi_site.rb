# This migration comes from spree_multi_site (originally 20150330045742)
class AddStoreDesignable < ActiveRecord::Migration
  # add feature store disignable 
  def change   
    add_column :spree_stores, :designable, :boolean, default: false     
    Spree::Site.where(:short_name=>['design','design2','design1']).each{|site|
      site.stores.first.update_attribute :designable, true      
    }     
  end
end

