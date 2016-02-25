require 'spree/permitted_attributes'
module Spree
  module PermittedAttributes
    ATTRIBUTES_FOR_THEME=[:page_layout_attributes,:param_value_attributes,:section_piece_param_attributes,
     :section_attributes, :template_file_attributes, :template_text_attributes, :template_theme_attributes,
     :comment_type_attributes, :comment_attributes]
    mattr_reader *ATTRIBUTES_FOR_THEME

    @@page_layout_attributes = [ :section_id,:title, :content_param, :data_source, :data_source_param, :css_class, :content_css_class, :stylish, :section_context ]
    @@param_value_attributes = [ :page_layout_root_id, :page_layout_id, :section_id ]
    @@section_piece_param_attributes = [ :editor,:param_category, :section_piece, :class_name, :pclass, :html_attribute_ids ]
    @@section_attributes = [ :section_piece_id, :title, :global_events, :subscribed_global_events,:is_enabled, :for_terminal ]
    @@template_file_attributes = [ :theme_id, :attachment, :page_layout_id, :alt ]
    @@template_text_attributes = [ :name, :body ]
    @@template_theme_attributes = [ :is_public, :site_id,:page_layout_root_id,:title, :section_root_id, :assigned_resource_ids, :for_terminal, :user_terminal_id ]
    @@product_attributes += [:global_taxon_ids, :global_taxons, :theme_id, :summary]
    @@taxon_attributes += [:page_context, :replaced_by, :is_clickable, :tooltips, :stylish]

    @@comment_type_attributes = [:name, :applies_to]
    @@comment_attributes = [:commentable_id, :commentable_type, :user_id, :comment_type_id, :comment, :cellphone, :email]

  end
end
