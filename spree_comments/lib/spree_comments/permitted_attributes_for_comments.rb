module Spree
  module PermittedAttributes
    ATTRIBUTES_FOR_COMMENTS=[:comment_type_attributes, :comment_attributes]
    mattr_reader *ATTRIBUTES_FOR_COMMENTS

    @@comment_type_attributes = [:name, :applies_to]
    @@comment_attributes = [:commentable_id, :commentable_type, :user_id, :comment_type_id, :comment, :cellphone, :email]
  end
end