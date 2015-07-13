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
  class CurrentPage < Menus::WrappedMenu

    attr_accessor :page_generator,:website_tag, :template_tag, :product_tag
    delegate :theme, :menu, :resource, :to => :page_generator
    delegate :is_preview, :to => :page_generator    
    delegate :design?, :to => :website_tag, :prefix=>"site"   
    alias_attribute :model, :menu #Menus::WrappedMenu use model
    
    def initialize(page_generator_instance)
      self.page_generator  = page_generator_instance
      self.website_tag = ::PageTag::WebsiteTag.new(page_generator_instance)
      self.template_tag = ::PageTag::TemplateTag.new(page_generator_instance)
      # it is required to generate path
      self.collection_tag = ::PageTag::Menus.new(self.template_tag)
      # get current product
      if self.page_generator.resource.present?
        self.product_tag = Products::WrappedProduct.new( self.collection_tag, page_generator.resource)
      else
        self.product_tag = nil
      end
    end
    
    #title is current page title,  resource.title-menu.title-website.title
    def title
      if detail_page?
        "#{resource.name} - #{menu.name} - #{website_tag.name}"
      else
        "#{menu.name} - #{website_tag.name}"    
      end      
    end

    #is given section context valid to current page 
    def valid_context?
      #Rails.logger.debug "valid=#{menu.current_context}, self.template_tag.current_piece=#{self.template_tag.current_piece.title}"
      ret = theme.valid_context?(template_tag.current_piece.page_layout, menu)
      #(self.template_tag.current_piece.context? menu.current_context)      
    end
    
    def detail_page?
      resource.present?
    end
    
    # when render for cart/account, should output '<%=yield %>'
    # store it in section piece would not work, controller.render_to_string would parse it.
    def reyield
      '<%=yield %>'
    end
  end
  
end

