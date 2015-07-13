module Spree
  module PermittedAttributes
    ATTRIBUTES_FOR_VARIANTS=[:ad_hoc_option_type_attributes, :ad_hoc_option_value_attributes, :customizable_product_option_attributes,
     :excluded_ad_hoc_option_value_attributes, :product_customization_type_attributes, :product_customization_attributes]
    mattr_reader *ATTRIBUTES_FOR_VARIANTS

    @@ad_hoc_option_type_attributes = [:is_required, :ad_hoc_option_values_attributes, :product_id, :option_type_id, :position]
    @@ad_hoc_option_value_attributes = [ :price_modifier, :ad_hoc_option_type_id, :option_value_id, :selected, :cost_price_modifier ]
    @@customizable_product_option_attributes = [ :name, :presentation, :description, :product_customization_type_id ]
    @@excluded_ad_hoc_option_value_attributes = [ :ad_hoc_variant_exclusion, :ad_hoc_option_value_id ]
    @@product_customization_type_attributes = [ :name, :presentation, :description, :customizable_product_options_attributes ]
    @@product_customization_attributes = [ :product_customization_type_id, :line_item_id ]
    
    @@product_attributes += [:product_customization_type_ids]
  end
end