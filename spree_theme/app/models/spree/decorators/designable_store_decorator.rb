Spree::Store.class_eval do
  # a template_theme belong to store now.
  # get themplate_themes belongs to designable store, TemplateTheme.foreign
  scope :designable, ->{ where( designable: true )}
end
