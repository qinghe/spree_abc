Spree::Product.class_eval do
  belongs_to :template_theme, :foreign_key=>"theme_id"
  attr_accessible :theme_id 
end