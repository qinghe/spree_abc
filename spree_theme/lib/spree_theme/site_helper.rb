module SpreeTheme
  module SiteHelper
    extend ActiveSupport::Concern
    included do
      has_many :template_texts, :foreign_key=>"site_id" #compatible with fack_websites
      # customer could select a theme when creating site.
      belongs_to :foreign_template_theme, :foreign_key=>'foreign_theme_id', :class_name=>'TemplateTheme'

      after_create :initialize_first_theme_if_selected # site_id is required for it
    end

    module ClassMethods
      #supply global taxon to other site.
      def globalsite
        dalianshops
      end
    end

    # customer could select a theme when creating site.
    def initialize_first_theme_if_selected
      if foreign_template_theme.present?
        self.class.with_site(self) {
          new_imported_theme = foreign_template_theme.import_with_resource
          self.stores.first.apply_theme( new_imported_theme )
        }
      end
    end

  end
end
