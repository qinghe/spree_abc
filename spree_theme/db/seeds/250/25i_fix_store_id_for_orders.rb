Spree::Order.unscoped.where(store_id: nil).each{|order|
  order.update_column :store_id, Spree::Store.unscoped.where(site_id: order.site_id).first.id
}
