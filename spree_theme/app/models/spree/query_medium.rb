module Spree

  # compatible query media for a template_theme
  class QueryMedium < ActiveRecord::Base
    has_many :template_query_media, dependent: :delete_all
  end
end
