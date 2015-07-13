module Spree
  
  # release information of template
  class TemplateRelease < ActiveRecord::Base
    belongs_to :template_theme, :foreign_key=>"theme_id"

    # set release id of template_theme
    after_create :set_current_release_id

    
    private
    def set_current_release_id
      self.template_theme.update_attribute :release_id, self.id
    end
  end
end