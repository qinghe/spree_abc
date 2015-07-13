require 'spree/core/controller_helpers/common'
class << Spree::Core::ControllerHelpers::Common  
  def included_with_theme_support(receiver)
    included_without_theme_support(receiver)
    receiver.send :include, SpreeTheme::System
    receiver.send :layout, :get_layout_if_use
    receiver.send :before_filter, :initialize_template
    receiver.send :before_filter, :add_view_path #spree_devise_auth, and spree_core require it.
  end
  alias_method_chain :included, :theme_support   
end

module SpreeTheme::System
  private
  # override spree's
  # only cart|account using layout while rendering, product list|detail page render without layout.
  def get_layout_if_use
    if request.xhr?
      return false
    end
    # keep it before check "designer", page for admin login never need design
    return @special_layout if @special_layout.present?

    #for designer
    return 'layout_for_design' if @is_designer

    #for customer, do not support it now.
    #if @is_preview 
    #  return 'layout_for_preview'
    #end  
    @theme.layout_path || SpreeTheme.site_class.current.layout || Spree::Config[:layout]
  end

  def initialize_template( request_fullpath = nil )
    request_fullpath ||= request.fullpath
    # in case  tld/create_admin_session, should show system layout, theme may have no login section. ex www.dalianshops.com
    @special_layout = nil
    #dalianshops use template now.
    #return if SpreeTheme.site_class.current.dalianshops?
    #Rails.logger.debug "request_fullpath=#{request_fullpath}"
    # fullpath may contain ?n=www.domain.com    
    case request_fullpath
      when /^\/under_construction/, /^\/user\/spree_user\/logout/ ,/^\/logout/, /^\/admin/
        return
    end  
      
    website = SpreeTheme.site_class.current
    # get theme first, then look for page for selected theme. design shop require index page for each template
    @is_designer = false
    if website.design?
      #add website condition, design can edit template_theme 
      @is_designer = ( Spree::TemplateTheme.accessible_by( current_ability, :edit).where(:site_id=>website.id).count >0 )
    end
    
    #login, forget_password page only available fore unlogged user. we need this flag to show editor even user have not log in.
    if cookies[:_dalianshops_designer]=='1'
      @is_designer = true
    end     
    if cookies[:_dalianshops_designer]=='0'
      @is_designer = false
    end     
    # user could select theme to view in design shop. 
    if website.design?
      #get template from query string
      if params[:action]=='preview' && params[:id].present?
        @theme = Spree::TemplateTheme.find( params[:id] )
        session[:theme_id] = params[:id]
      end
      if session[:theme_id].present?
        if Spree::TemplateTheme.exists? session[:theme_id]  #theme could be deleted.
          @theme = Spree::TemplateTheme.find( session[:theme_id] )
        end
      end
    end
    #browse template by public
    if @theme.blank? and SpreeTheme.site_class.current.template_theme.present?       
      @theme = SpreeTheme.site_class.current.template_theme
    end
#Rails.logger.debug "@theme=#{@theme.inspect}, @is_designer=#{@is_designer},website=#{website.inspect} request.xhr?=#{request.xhr?}"
    if params[:controller]=~/cart|checkout|order/
      @menu = DefaultTaxon.instance
    elsif params[:controller]=~/user/
      @menu = DefaultTaxon.instance
    else
      if params[:r]
        @resource = Spree::Product.find_by_id(params[:r])
      end
      if params[:p]
        @resource = Spree::Post.find_by_id(params[:p])
      end
      if params[:c] && params[:c].to_i>0 
        @menu = SpreeTheme.taxon_class.find_by_id(params[:c])
      elsif(( index_page = @theme.try(:index_page)) && index_page > 0 )
        @menu = SpreeTheme.taxon_class.find_by_id(index_page)
      elsif(( index_page = website.index_page) > 0 )
        @menu = SpreeTheme.taxon_class.find_by_id(index_page)
      #elsif SpreeTheme.taxon_class.home.present? 
      # #it is discarded, it is conflict with feature theme has own index page. it would show product assigned index page of other theme   
      # #now each theme has own index page. website has own index page. 
      # #just set home page in taxon is ok as well       
      #  @menu = SpreeTheme.taxon_class.home
      else
        # get default_taxon from root, or it has no root, inherited_page_context cause error
        @menu = DefaultTaxonRoot.instance(request_fullpath).children.first
      end
    end
    #menu should be same instance pass to PageTag::PageGenerator, it require  request_fullpath
    @menu.request_fullpath = request_fullpath
    # support feature replaced_by 
    if @menu.replacer.present?
      @menu = @menu.replacer
    end

    # @theme is required since we support create admin session by ajax.    
    case request_fullpath
      when /^\/create_admin_session/,/^\/new_admin_session/
        @special_layout = 'layout_for_login'
        return
      when /^\/comments/ # it need layout when development, in fact it is always ajax.
        @special_layout = 'under_construction'
        return        
    end  
    
    # site has a released theme    
    if @theme.present?  
      unless request.xhr?
        if @is_designer      
           prepare_params_for_editors(@theme)
           # layout_editor_panel has to be in views/application, 
           # or could not find for spree_auth_devise/controllers
           @editor_panel = render_to_string :partial=>'layout_editor_panel'
        end
      end
      # we have initialize PageTag::PageGenerator here, page like login  do not go to template_thems_controller/page
      if @is_designer
        @lg = PageTag::PageGenerator.previewer( @menu, @theme, {:resource=>@resource, :controller=>self, :page=>params[:page]})                  
      else
        @lg = PageTag::PageGenerator.generator( @menu, @theme, {:resource=>@resource, :controller=>self, :page=>params[:page]})          
      end      
      @lg.context.each_pair{|key,val|
        # expose variable to view
        instance_variable_set( "@#{key}", val)
      }      
    else
      redirect_to :under_construction
    end
  end
  
  def prepare_params_for_editors(theme,editor=nil,page_layout = nil)
      @editors = Spree::Editor.all
      @param_values_for_editors = Array.new(@editors.size){|i| []}
      editor_ids = @editors.collect{|e|e.id}
      page_layout ||= theme.page_layout
      param_values =theme.param_values().includes([:section_param=>[:section_piece_param=>:param_category]]).where(["spree_param_values.page_layout_id=? and spree_section_params.is_enabled",page_layout.id]).order("spree_param_categories.position, spree_section_params.section_id, spree_section_piece_params.position") 
      #get param_values for each editors
      for pv in param_values
        #only get pv blong to root section
        #next if pv.section_id != layout.section_id or pv.section_instance != layout.section_instance
        idx = (editor_ids.index pv.section_param.section_piece_param.editor_id)
        if idx>=0
          @param_values_for_editors[idx]||=[]        
          @param_values_for_editors[idx] << pv
        end
      end 
  
      @theme =  theme   
      @editor = editor    
      @editor ||= @editors.first
      
      @page_layout = page_layout #current selected page_layout, the node of the layout tree.
      @page_layout||= theme.page_layout
      @sections = Spree::Section.where(:is_enabled=>true).order("title").roots
      #template selection
      @template_themes = Spree::TemplateTheme.where(:site_id=>SpreeTheme.site_class.current.id)
  end
  
  def add_view_path
    #!!is it a place cause memory overflow?
    append_view_path SpreeTheme.site_class.current.document_path
    # layout of imported theme is in design site home folder 
    append_view_path SpreeTheme.site_class.designsite.document_path
  end
end