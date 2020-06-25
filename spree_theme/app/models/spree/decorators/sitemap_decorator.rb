Spree::Product.class_eval do
  def self.last_updated
    last_update = order('spree_products.updated_at DESC').first
    last_update.try(:updated_at)
  end
end
