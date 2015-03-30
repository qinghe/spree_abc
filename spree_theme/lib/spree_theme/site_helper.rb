module SpreeTheme
  module SiteHelper
    extend ActiveSupport::Concern
    included do
      belongs_to :template_theme, :foreign_key=>"theme_id"
      has_many :template_texts, :foreign_key=>"site_id" #compatible with fack_websites
      has_many :template_themes, :foreign_key=>"site_id", :dependent=>:destroy
      # customer could select a theme when creating site.
      belongs_to :foreign_template_theme, :foreign_key=>'foreign_theme_id', :class_name=>'TemplateTheme'
      
      after_create :initialize_first_theme_if_selected # site_id is required for it
    end
    
    module ClassMethods
      #supply global taxon to other site.
      def globalsite
        dalianshops
      end
      
      if Rails.env.test?    
        def current
          if Thread.current[:spree_site].nil?
            website = self.find_or_initialize_by_domain_and_name('design.dalianshops.com','DalianShops Design Site' )
            #or Rails.env.development?
            if website.new_record?
              website.id = 2
              website.theme_id = 1
              website.save!
            end            
            Thread.current[:spree_site] = website
          end
          Thread.current[:spree_site]
        end
        
        def current=(some_site)
          ::Thread.current[:spree_site] = some_site      
        end
      end      
      # shop's resource should be in this folder
      def document_root
        File.join(Rails.root,'public') 
      end
      
    end  

    def document_path
      self.class.document_root + self.path
    end
    
    def path
      File.join( File::SEPARATOR + 'shops', Rails.env, self.id.to_s )
    end
    
    def layout
      self.template_theme.present? ? self.template_theme.layout_path : nil
    end
      
    # apply theme to site
    # params - theme_or_release, TemplateTheme or TemplateRelease
    def apply_theme( theme)
      self.theme_id= theme.id           
      save!
    end
    
    # customer could select a theme when creating site.
    def initialize_first_theme_if_selected
      if foreign_template_theme.present?
        self.class.with_site(self) {
          new_imported_theme = foreign_template_theme.import_with_resource
          self.apply_theme( new_imported_theme )          
        }      
      end
    end
    
  end
end