Spree::Order.class_eval do
  acts_as_commentable
end

Spree::Shipment.class_eval do
  acts_as_commentable
end

Spree::TemplateTheme.class_eval do
  acts_as_commentable
end

Spree::Store.class_eval do
  acts_as_commentable
end
