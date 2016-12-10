require 'spree/core/controller_helpers/common'
# spree/api/base>action_base, spree/base>application
# both included controller_helper/store
class << Spree::Core::ControllerHelpers::Common
  def included_with_theme_support(receiver)
    included_without_theme_support(receiver)
    receiver.send :include, SpreeTheme::System
    # template holds data for page render, we have to initialize it even for api
    #receiver.send :before_filter, :initialize_template
    receiver.send :prepend_before_action, :initialize_template
    # receiver could be Spree::Api::BaseController or  Spree::BaseController
    #if receiver == Spree::BaseController
    #receiver.send :before_filter, :add_view_path #spree_devise_auth, and spree_core require it.
    receiver.send :layout, :get_layout_if_use # never allow it to api controller.

  end
  alias_method_chain :included, :theme_support
end

module SpreeTheme
  module System
    private
    # override spree's
    # only cart|account using layout while rendering, product list|detail page render without layout.
    def get_layout_if_use

      if request.xhr?
        return false
      end
      # keep it before check "designer", page for admin login never need design
      return @special_layout if @special_layout.present?
      #disable mobile feature for now
      #return 'sprangular/application' if mobile?
      #for designer
      return 'layout_for_design' if @is_designer

      #for customer, do not support it now.
      #if @is_preview
      #  return 'layout_for_preview'
      #end
      @theme.layout_path || Spree::Store.current.layout || Spree::Config[:layout]
    end

    def initialize_template( request_fullpath = nil )
      request_fullpath ||= request.fullpath

      # in case  tld/create_admin_session, should show system layout, theme may have no login section. ex www.dalianshops.com
      @special_layout = nil
      # dalianshops use template now.
      # Rails.logger.debug "request_fullpath=#{request_fullpath}"
      # fullpath may contain ?n=www.domain.com
      case request_fullpath
      when /^\/under_construction/, /^\/user\/spree_user\/logout/ ,/^\/logout/, /^\/admin/
          return
      end

      website = Spree::Store.current
      # get theme first, then look for page for selected theme. design shop require index page for each template
      @is_designer = false
      if website.designable?
        #add website condition, design can edit template_theme
        @is_designer = ( Spree::TemplateTheme.accessible_by( current_ability, :edit).where(:site_id=>website.site_id).count >0 )
      end
      # allow edit mobile template on chrome
      #@is_designer = false if mobile?
      #login, forget_password page only available fore unlogged user. we need this flag to show editor even user have not log in.
      @is_designer = ( cookies[:_dalianshops_designer]=='1')  if cookies[:_dalianshops_designer].present?

      @client_info = current_terminal
      @client_info.is_preview = @is_designer

      #current_user.is_designer means he could design template_theme.
      #current_site.designable means current user could preview published template_theme
      # user could select theme to view in editor.
      if  website.designable?
        #get template from query string
        if params[:action]=='preview' && params[:id].present?
          @theme = Spree::TemplateTheme.find( params[:id] )
          session[:theme_id] = params[:id]
        end
        # there are more than one designable website,  design1, design2 ....
        # since cookies domain is same top level domain, ex. .dalianshops.com
        # session[:theme_id] maybe not belong to current website, we should test that.
        if session[:theme_id].present?
          if Spree::TemplateTheme.native.exists? session[:theme_id]  #theme could be deleted.
            @theme = Spree::TemplateTheme.find( session[:theme_id] )
          else
            session[:theme_id] = nil
          end
        end
      end
      # public view pages
      if @theme.blank? && Spree::Store.current.template_theme.present?
        @theme = Spree::Store.current.template_theme
      end
  #Rails.logger.debug "@theme=#{@theme.inspect}, @is_designer=#{@is_designer},website=#{website.inspect} request.xhr?=#{request.xhr?}"
      if params[:controller]=~/cart|checkout|order/
        @menu = get_default_taxon
      elsif params[:controller]=~/user/
        @menu = get_default_taxon
      else
        if params[:r]
          @resource = Spree::Product.find_by_id(params[:r])
        end
        if params[:p]
          @resource = Spree::Post.find_by_id(params[:p])
        end
        if params[:c] && params[:c].to_i>0
          @menu = SpreeTheme.taxon_class.find_by_id(params[:c])
        end
        # get default_taxon from root, or it has no root, inherited_page_context cause error
        # @theme could be nil at present.
        @menu ||= ( @theme.try(:home_page) || website.home_page || get_default_taxon)
        #elsif SpreeTheme.taxon_class.home.present?
        # #it is discarded, it is conflict with feature theme has own index page. it would show product assigned index page of other theme
        # #now each theme has own index page. website has own index page.
        # #just set home page in taxon is ok as well
        #  @menu = SpreeTheme.taxon_class.home
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
        when /^\/comments/,/^\/new_site/,/^\/create_site/ # it need layout when development, in fact it is always ajax.
          @special_layout = 'under_construction'
          return
      end

      # site has a released theme
      if @theme.present?
        #support feature is_public
        unless website.is_public?
          #if it is not public, only admin could preview template_theme.
          unless try_spree_current_user
            redirect_to :under_construction
          end
        end

        if mobile? && @theme.mobile
          @theme = @theme.mobile
        end

        unless request.xhr?
          if @is_designer
             prepare_params_for_editors(@theme)
             # layout_editor_panel has to be in views/application,
             # or could not find for spree_auth_devise/controllers
             # do not use render_to_string... it is time consuming.
             #@editor_panel = render_to_string :partial=>'layout_editor_panel'
          end
        end

        # initialize page generator @lg all the time, even for xhr, we need to partial section. ex. minicart
        # we have to initialize PageTag::PageGenerator here, page like login  do not go to template_thems_controller/page
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

    def prepare_params_for_editors(theme,editor=nil,page_layout = nil, template_terminal = nil)
        @editors = Spree::Editor.all
        @param_values_for_editors = Array.new(@editors.size){|i| []}
        editor_ids = @editors.collect{|e|e.id}
        page_layout ||= theme.original_page_layout_root
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
        #it is not done, comment it out for now.
        #@template_terminal = template_terminal
        #@template_terminal ||= theme.template_terminals.first
        @page_layout = page_layout #current selected page_layout, the node of the layout tree.
        @sections = Spree::Section.where(:is_enabled=>true).order("title").roots
        #template selection, include mobile
        @template_themes = Spree::TemplateTheme.native
    end

    def add_view_path

    end

    #https://ruby-china.org/topics/22165
    #https://github.com/ruby-china/ruby-china/blob/13662590b382c7bbc2438d79679df68efe2684a1/app/helpers/application_helper.rb
    MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                          'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                          'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                          'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                          'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
    def mobile?
      return true if cookies[:_dalianshops_terminal]=='2'

      agent_str = request.user_agent.to_s.downcase
      return false if agent_str =~ /ipad/
      agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
    end

    def current_terminal
      unless @current_terminal
        @current_terminal = ( mobile? ? Spree::UserTerminal.cellphone.first : Spree::UserTerminal.pc.first )
      end
      @current_terminal
    end

    def get_default_taxon(  )
      DefaultTaxonRoot.instance(request.fullpath).children.first
    end
  end
end
