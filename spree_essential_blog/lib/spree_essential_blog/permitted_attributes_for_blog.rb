module Spree
  module PermittedAttributes
    ATTRIBUTES_FOR_BLOG=[:blog_attributes, :post_attributes, :post_file_attributes, :post_product_attributes]
    mattr_reader *ATTRIBUTES_FOR_BLOG

    @@blog_attributes = [:name, :permalink]
    @@post_attributes = [ :title, :cover, :teaser, :body, :posted_at, :author, :live, :tag_list, :taxon_ids, :product_ids_string, :meta_keywords, :meta_description]
    @@post_file_attributes = [:alt, :attachment]
    @@post_product_attributes = [:post_id, :product_id, :position]
  end
end