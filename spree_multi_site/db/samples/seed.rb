files = ["zones",
   "payment_methods",
  "shipping_categories",
  "shipping_methods",
  "tax_categories",
  "tax_rates",
  "products",
  "taxonomies",
  "taxons",
  "option_types",
  "option_values",
  "product_option_types",
  "product_properties",
  "prototypes",
  "variants",
  "stock",
  "assets"]
for file in files
  path = File.join(File.dirname(__FILE__), "#{file}.rb")
Rails.logger.debug "start load #{file}"     
  load path
end