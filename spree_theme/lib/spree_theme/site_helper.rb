module SpreeTheme
  module SiteHelper
    extend ActiveSupport::Concern
    included do     
      belongs_to :template_theme, :foreign_key=>"theme_id"
      belongs_to :template_release, :foreign_key=>"template_release_id"
      attr_accessible :index_page,:theme_id
    end
    
    module ClassMethods
      def designsite
        find_by_domain 'design.dalianshops.com'
      end     
         
      def current
        if Thread.current[:spree_site].nil?
          website = self.find_or_initialize_by_domain_and_name('design.dalianshops.com','DalianShops Design Site' )
          if website.new_record?
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
      
      # shop's resource should be in this folder
      def document_root
        File.join(Rails.root,'public') 
      end
      
      def document_layout_path
        File.join( document_root, 'shops', Rails.env )
      end
    end  

    def document_path
      self.class.document_root + self.path
    end
    
    def path
      File.join( File::SEPARATOR + 'shops', Rails.env, self.id.to_s )
    end
    
    def layout
      self.template_release.present? ? self.template_release.layout_path : nil
    end
      
    def design?
      self == self.class.designsite
    end 
    
    # apply theme to site
    # params - theme_or_release, TemplateTheme or TemplateRelease
    def apply_theme( theme_or_release)
      if theme_or_release.kind_of? Spree::TemplateTheme
        template_release_id= 0
        template_id= theme_or_release.id           
      else
        template_release_id= theme_or_release.id
        template_id= 0        
      end
      save!
    end
  end
end