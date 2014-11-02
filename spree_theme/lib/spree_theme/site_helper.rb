module SpreeTheme
  module SiteHelper
    extend ActiveSupport::Concern
    included do
      belongs_to :template_theme, :foreign_key=>"theme_id"
      has_many :template_themes, :foreign_key=>"site_id" #compatible with fack_websites
      has_many :template_texts, :foreign_key=>"site_id" #compatible with fack_websites
      #belongs_to :template_release, :foreign_key=>"template_release_id"
      attr_accessible :index_page,:theme_id
    end
    
    module ClassMethods
      #supply global taxon to other site.
      def globalsite
        dalianshops
      end
      
      def designsite
        find_by_short_name('design')
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