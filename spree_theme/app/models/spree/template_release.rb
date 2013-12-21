module Spree
  
  # release information of template
  class TemplateRelease < ActiveRecord::Base
    belongs_to :template_theme, :foreign_key=>"theme_id"

    # path for rails looking for layout.
    def layout_path
      File.join( "t#{self.theme_id}_r#{self.id}", template_theme.file_name( "ehtml" ))
    end

    # folder name 'layouts' is required, rails look for layout in folder named 'layouts'
    def path
      File.join( File::SEPARATOR+'layouts', "t#{self.theme_id}_r#{self.id}")
    end
    
    def document_path
      File.join( template_theme.website.document_path, self.path)
    end
    
    # * params
    #   * targe - could be css, js
    # * return js or css document file path, ex /shops/development/1/layouts/t1_r1/l1_t1.css
    def file_path( target )
       File.join(template_theme.website.path, self.path, template_theme.file_name(target))
    end
    
    def document_file_path( target )
      File.join( document_path, template_theme.file_name(target) )
    end
    
  end
end