Spree::Product.class_eval do
  include TemplateResourcePath
end

SpreeTheme.post_class.class_eval do
  include TemplateResourcePath
end
