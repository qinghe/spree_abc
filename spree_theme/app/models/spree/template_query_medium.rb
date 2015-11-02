#copy from spree/core/model/spree/classification
module Spree
  class TemplateQueryMedium < ActiveRecord::Base
    self.table_name = 'spree_template_themes_query_media'
    acts_as_list scope: :template_theme
    belongs_to :query_medium, class_name: "Spree::QueryMedium", inverse_of: :template_query_media, touch: true
    belongs_to :template_theme, class_name: "Spree::TemplateTheme", touch: true
  end
end
