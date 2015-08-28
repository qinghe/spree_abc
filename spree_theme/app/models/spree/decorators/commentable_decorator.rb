Spree::Order.class_eval do
  acts_as_commentable
end

Spree::Shipment.class_eval do
  acts_as_commentable
end

Spree::TemplateTheme.class_eval do
  acts_as_commentable
end

SpreeTheme.site_class.class_eval do
  acts_as_commentable
end
