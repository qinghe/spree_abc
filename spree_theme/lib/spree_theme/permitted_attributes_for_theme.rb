module Spree
  module PermittedAttributes
    ATTRIBUTES_FOR_THEME=[:page_layout_attributes,:param_value_attributes,:section_piece_param_attributes,
     :section_attributes, :template_file_attributes, :template_text_attributes, :template_theme_attributes ]
    mattr_reader *ATTRIBUTES_FOR_THEME

    @@page_layout_attributes = [ :section_id,:title ]
    @@param_value_attributes = [ :page_layout_root_id, :page_layout_id,:section_id ]
    @@section_piece_param_attributes = [ :editor,:param_category, :section_piece, :class_name, :pclass, :html_attribute_ids ]
    @@section_attributes = [ :section_piece_id, :title, :global_events, :subscribed_global_events,:is_enabled, :for_terminal ]
    @@template_file_attributes = [ :theme_id, :attachment, :page_layout_id ]
    @@template_text_attributes = [ :name, :body ]
    @@template_theme_attributes = [ :is_public, :site_id,:page_layout_root_id,:title, :section_root_id, :assigned_resource_ids, :for_terminal ]
    @@product_attributes += [:global_taxon_ids, :global_taxons, :theme_id]
    @@taxon_attributes += [:page_context, :replaced_by, :is_clickable, :tooltips]
  end
end