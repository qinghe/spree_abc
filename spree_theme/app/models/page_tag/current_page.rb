# current page, it is current menu item.
# current_page -> website
#              -> template -> param_values
#                          -> menus
#                          -> named_resource (blog_posts, products)
#                          -> current_resource( product, blog_post )
#                          # those tags required current section_instance
#                   
# tags in page
# template.current_section.menu == template.menus.select
# template.current_section.param_values == template.param_values.select
module PageTag
  class CurrentPage < Base

    attr_accessor :website_tag, :template_tag
    delegate :menu, :to => :page_generator
    delegate :resource,:is_preview, :to => :page_generator
    
    def initialize(page_generator_instance)
      super(page_generator_instance)
      self.website_tag = ::PageTag::WebsiteTag.new(page_generator_instance)
      self.template_tag = ::PageTag::TemplateTag.new(page_generator_instance)
    end
    
    #title is current page title,  resource.title-menu.title-website.title
    def title
      "#{menu.name} - #{website_tag.name}"
    end
    
    #get current page's resource by template.current_piece 
    def resources()
      objs = []
      data_source = self.template_tag.current_piece.data_source
      if data_source.present?
        if data_source == 'gpvs'
          #objs = menu.products
          #copy from taxons_controller#show
          @searcher = Spree::Config.searcher_class.new({:taxon => menu.id})
          #@searcher.current_user = try_spree_current_user
          #@searcher.current_currency = current_currency
          objs = @searcher.retrieve_products
        elsif data_source == 'this_product'
          #default_taxon.id is 0 
          objs = [self.resource] #menu.products.where(:id=>resource.id)        
        end
        if objs.present?
          objs = Products.new( self.page_generator, objs)
        end
      end
      objs
    end
    
    #is given section context valid to current page 
    def valid_context?
      (self.template_tag.current_piece.context? menu.current_context)      
    end
    
    # when render for cart/account, should output '<%=yield %>'
    # store it in section piece would not work, controller.render_to_string would parse it.
    def reyield
      '<%=yield %>'
    end
  end
  
end

