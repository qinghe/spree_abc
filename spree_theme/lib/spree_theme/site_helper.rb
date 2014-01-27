module SpreeTheme
  module SiteHelper
    extend ActiveSupport::Concern
    included do
      cattr_accessor :designshop_url
      belongs_to :template_theme, :foreign_key=>"theme_id"
      belongs_to :template_release, :foreign_key=>"template_release_id"
      attr_accessible :index_page,:theme_id
      self.designshop_url = 'design.dalianshops.com'
    end
    
    module ClassMethods
      def designsite
        find_by_domain designshop_url
      end     
         
      def current
        if Thread.current[:spree_site].nil?
          website = self.find_or_initialize_by_domain_and_name(designshop_url,'DalianShops Design Site' )
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
      
    def design?
      self == self.class.designsite
    end 
    
    # apply theme to site
    # params - theme_or_release, TemplateTheme or TemplateRelease
    def apply_theme( theme)
      self.theme_id= theme.id           
      save!
    end
  end
end