module Spree
  module Api
    module ApiHelpers
      ATTRIBUTES_FOR_THEME = [
        :page_layout_attributes]

      mattr_reader *ATTRIBUTES_FOR_THEME

      @@page_layout_attributes = [
        :id, :title, :parent_id, :template_theme_id
      ]
    end
  end
end
