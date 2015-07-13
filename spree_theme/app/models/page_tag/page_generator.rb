#in layout, there are some eruby, all available varibles should be here.
module PageTag 
  class PageGenerator
    
    attr_accessor :template_release, :menu, :theme, :resource # resource could be product, blog_post, flash, file, image...
    attr_accessor :editor
  
    #these attributes are for templates
    attr_accessor :current_page_tag
    attr_accessor :context
    # * renderer - could be current controller or Erubis::Eruby,  
    #    we would like to use helper method of rails, so now is using controller as renderer
    # * resource_options - parameter for resource, for example, pagination
    attr_accessor :is_preview, :controller, :renderer, :resource_options
    #
    attr_accessor :ehtml, :ecss, :ejs, :ruby 
    delegate :generate, :generate_assets, :to=>:renderer
    delegate :html,:css,:js, :to=>:renderer
  
    class << self
      #page generator has two interface, builder and generator
      #builder only build content: ehtml,js,css
      #def builder( theme )
      #  self.new( theme, menu=nil)      
      #end
      
      #designer release a template
      def releaser( theme)
        pg = self.new( theme, menu=nil)
        pg.build
        pg
      end
      
      #generator generate content: html,js,css
      # params:
      #   theme: template theme,  a template may not released.
      def previewer(menu, theme=nil,  options={})
        options[:preview] = true
        pg = self.new( theme, menu, options)
        pg.build
        pg
      end    
      #generator generate content: html,js,css
      def generator(menu, theme=nil,  options={})
        self.new( theme, menu, options)
      end
    end
    
    def initialize( theme, menu, options={})        
      self.theme = theme
      self.menu = menu
      self.resource = nil
      self.is_preview = options[:preview].present?
      
      self.editor = options[:editor]
      if options[:resource].present?
        self.resource = options[:resource]
      end
      html = css = js = nil
      ehtml = ecss = ejs = nil
      #init template variables, used in templates
      self.current_page_tag = PageTag::CurrentPage.new(self)
      initialize_context_variables
      if options[:controller].present?
        self.controller = options[:controller]
      end       
      self.resource_options = options.slice(:page)
    end
    
    def url_prefix      
      #self.is_preview ? "/preview" : ""
      ""
    end
    
    #def has_editor?
    #  self.editor.present?
    #end
  
    #build html, css sourse
    def build
      self.ehtml, self.ecss, self.ejs = self.theme.page_layout.build_content()      
      return self.ehtml, self.ecss, self.ejs
    end
    
    def release
      #build -> generate_assets -> serialize
      self.build            # build ehtml, ecss, ejs
      self.generate_assets  # generate css, js
      self.ruby = erb.new(self.ehtml).src 
      serialize_page(:ehtml)
      serialize_page(:css)
      serialize_page(:js)
      serialize_page(:ruby)
    end
    
    def renderer
      if @renderer.blank?     
        if self.controller.present?
          @renderer = PageTag::PageRenderer::RailsRenderer.new(self.ehtml, self.ecss, self.ejs, self.context,self.controller)
        else
          @renderer = PageTag::PageRenderer::ErubisRenderer.new(self.ehtml, self.ecss, self.ejs, self.context)
        end
      end    
      @renderer
    end
   
    def build_path( wrapped_model )    
      url = nil
      if wrapped_model.kind_of?( Menus::WrappedMenu )
        url= url_prefix+ wrapped_model.model.path
      else          
        url= url_prefix+ wrapped_model.path    
      end    
      url
    end
    
    # *specific_attribute - ehtml,ecss, html, css
    def serialize_page(specific_attribute)
      specific_attribute_collection = [:css,:js,:ehtml,:ruby]
      raise ArgumentError unless specific_attribute_collection.include?(specific_attribute)
      page_content = send(specific_attribute)
      if page_content.present?
        path = self.theme.document_path
        FileUtils.mkdir_p(path) unless File.exists?(path)
  
        path = self.theme.document_file_path(specific_attribute)      
        open(path, 'w') do |f|  f.puts page_content; end
      end
    end
  
    private
    # erb context variables 
    def initialize_context_variables
      self.context = {:current_page=>current_page_tag, 
        :website=>current_page_tag.website_tag, :template=>current_page_tag.template_tag
        }    
    end  
  
    def erb( )
      ActionView::Template::Handlers::ERB.erb_implementation
    end
  end
end  