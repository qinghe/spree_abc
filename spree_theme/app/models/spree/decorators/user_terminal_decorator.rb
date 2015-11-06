Spree::PaymentMethod.class_eval do
  belongs_to :terminal
end

Spree::TemplateTheme.class_eval do
  belongs_to :terminal
end

Spree::Order.class_eval do
  belongs_to :terminal
end
