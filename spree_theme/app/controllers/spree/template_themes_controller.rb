module Spree
  class TemplateThemesController < Spree::StoreController
    helper 'spree/products'
    delegate :taxon_class,:site_class, :to=>:"SpreeTheme"

    # support database_theme and file_theme
    def page
      if file_theme_instance.present?
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
        @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
        @taxonomies = Spree::Taxonomy.includes(root: :children)
        render file_theme_instance.index_page
      end
    end

    def under_construction
      #logger.debug "request.env[/devise/]= #{request.env['devise.mapping']},#{warden.inspect}"
      #require spree_auth_devise
      render "under_construction", layout: "under_construction"
    end

    # @theme is required for xhr
    def new_admin_session
      #@user = Spree::User.new
    end

    # @theme is required for xhr
    def create_admin_session
      user_params = params[:spree_user]
      @user = Spree.user_class.unscoped.admin.find_for_authentication(:email => user_params[:email])
      if @user.present?
        if @user.valid_password?(user_params[:password])
          sign_in :spree_user, @user
        end
      end
      #spree_user_signed_in? defined in devise/lib/controllers/helpers.rb
      if spree_user_signed_in?
        #warden.authenticate?
        # host is required, current_user.site may not be current site, we allow user login from dalianshops.com
        respond_with  do |format|
          #  site_custom_domain/admin conficlt with site.dalianshops.com/admin
          #  current host maybe dalianshops.com or custom domain
          if is_from_system_domain?
            format.html{ redirect_to admin_url(:host=> current_spree_user.site.subdomain ) }
          else
            format.html{ redirect_to admin_url }
          end
        end
      else
        flash.now[:error] = t('devise.failure.invalid')
        render "new_admin_session"
      end
    end



    # params for preview
    #    d: domain of website
    #    c: menu_id
    def preview
    end

    # params
    #   layout_id: selected page_layout_id
    #   selected_section_id: selected section_root_id
    def update_layout_tree
      @theme = TemplateTheme.find(params[:id])
      op = params[:op]
      selected_page_layout_id = params[:layout_id]
      selected_section_id = params[:selected_section_id]
      selected_type = params[:selected_type]
      @selected_page_layout = @theme.page_layouts.find(selected_page_layout_id)
      if op=='promote'
        @selected_page_layout.promote
      elsif op=='demote'
        @selected_page_layout.demote
      elsif op=='move_left'
        @selected_page_layout.move_left
      elsif op=='move_right'
        @selected_page_layout.move_right
      elsif op=='add_child'
        section = Spree::Section.roots.find(selected_section_id)
        #if selected_type=='Section'
        @theme.add_section(section,@selected_page_layout)
        #else
        #  @selected_page_layout.add_layout_tree(selected_id)
        #end
        #@layout.reload
      elsif op=='del_self'
        @selected_page_layout.destroy unless @selected_page_layout.root?
        @selected_page_layout = @selected_page_layout.parent
        #FIXME update param_values in editor
        #@layout.reload
      end
      @theme.page_layout_root.reload #layout is changed
      render :partial=>"layout_tree1"
    end

    # user disable a section in the current layout tree
    def disable_section
      layout_id = params[:layout_id]
      layout = PageLayout.find(layout_id)
      se = PageEvent::SectionEvent.new("disable_section", layout )
      se.notify
    end

    def get_param_values
      theme_id = params[:selected_theme_id]
      editor_id = params[:selected_editor_id]
      layout_id = params[:selected_page_layout_id]

      theme = TemplateTheme.find(theme_id)
      editor = Editor.find(editor_id)
      page_layout = PageLayout.find(layout_id)
      prepare_params_for_editors(theme, editor, page_layout)

      respond_to do |format|
        format.html
        format.js  {render :partial=>'editors1'}
      end
    end

    # * params - terminal_id

    def update_param_value
      param_value_event = params[:param_value_event]
      editing_param_value_id = params[:editing_param_value_id].to_i
      editing_html_attribute_id = params[:editing_html_attribute_id].to_i
      theme_id = params[:selected_theme_id]
      editor_id = params[:selected_editor_id]
      layout_id = params[:selected_page_layout_id]
      terminal_id = params[:terminal_id]
      param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}

        param_value_params = params["pv#{editing_param_value_id}"]
        source_param_value = ParamValue.includes(:section_param).find(editing_param_value_id)
        updated_html_attribute_values = do_update_param_value(source_param_value, param_value_params, param_value_event, editing_html_attribute_id)

      #  param_value = ParamValue.find(editing_param_value_id)
      theme = TemplateTheme.find(theme_id)
      editor = Editor.find(editor_id)
      page_layout = PageLayout.find(layout_id)
      user_terminal = nil#UserTerminal.where( terminal_id: terminal_id ).first
      prepare_params_for_editors(theme,editor, page_layout, user_terminal)

      respond_to do |format|
        format.html
        format.js  {render :partial=>'update_param_value',:locals=>{:source_param_value=>source_param_value,:updated_html_attribute_values=>updated_html_attribute_values}}
      end

    end




    # Usage, update a param_value by param_value_param
    # Params, param_value ParamValue instance
    #         param_value_params, hash, format as {"84"=>{"pvalue"=>"section_name", "psvalue"=>"0t"}}
    # Return, all updated_html_attribute_values, may include html_attribute_value belongs to other section, also include the source change, it is the first,
    #         it cause the serial changes.
    def do_update_param_value(param_value, param_value_params, param_value_event, editing_html_attribute_id)
      html_attribute = html_attribute_value_params = nil
      param_value_params.keys.each {|ha_id|
        ha_id = ha_id.to_i
        if editing_html_attribute_id.nil? or editing_html_attribute_id==ha_id
          html_attribute = HtmlAttribute.find_by_ids(ha_id)
          html_attribute_value_params = param_value_params[ha_id.to_s]
          #event_params = {:html_attribute=>html_attribute,:html_attribute_value_params=>html_attribute_value_params}
          #param_value.raise_event(param_value_event, event_params)
        end
      }
      param_value.update_html_attribute_value(html_attribute, html_attribute_value_params, param_value_event )
      #param_value.save
      param_value.updated_html_attribute_values
    end

    # usage - 1. popup file upload dialog
    #         2. handle submitted file
    # params
    #   html_attribute_id
    #   param_value_id,
    #   template_file - {"attachment"=>#<ActionDispatch::Http::UploadedFile:0xc9e77ec @original_filename="老郎酒1956精品酱香型531.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"template_file[attachment]\"; filename=\"\xE8\x80\x81\xE9\x83\x8E\xE9\x85\x921956\xE7\xB2\xBE\xE5\x93\x81\xE9\x85\xB1\xE9\xA6\x99\xE5\x9E\x8B531.jpg\"\r\nContent-Type: image/jpeg\r\n", @tempfile=#<File:/tmp/RackMultipart20130405-18221-1riv34n>>}
    def upload_file_dialog
      @dialog_content="upload_dialog_content"
      @param_value_id = params[:param_value_id]
      @html_attribute_id = params[:html_attribute_id].to_i
      @param_value = ParamValue.includes(:section_param=>:section_piece_param).find(@param_value_id)
      #@editor = @param_value.section_param.section_piece_param.editor
      if request.post?
        #TODO replace same name of template file
        uploaded_image = TemplateFile.new(  params.require(:template_file).permit! )
        uploaded_image['theme_id']=@param_value.theme_id
        uploaded_image.save!
        # update param value to selected uploaded image
        param_value_params={@html_attribute_id.to_s=>{"unset"=>"0", "pvalue0"=>uploaded_image.attachment_file_name, "psvalue0"=>"0i"}}
        param_value_event = ParamValue::EventEnum[:pv_changed]
        editing_html_attribute_id = @html_attribte_id
        @updated_html_attribute_values = do_update_param_value(@param_value, param_value_params, param_value_event, editing_html_attribute_id)
        # get all param values by selected editor
        # update param value
        render :partial=>'after_upload_dialog'
      else
        @theme = TemplateTheme.find(@param_value.theme_id)
        render "dialog_for_editor"

      end
    end


    def check_upload_file_name
      file_name = params[:file_name]
      is_existing = TemplateFile.exists?( ["file_name=?", file_name])
      if is_existing
        # render "replace"
      else
        # render "upload"
      end
    end

    # path for /new_site,  view new_site is placeholder as cart, account...
    def new_site

    end

    private
    def model_dialog(dialog_title, dialog_content)
      @dialog_title = dialog_title
      @content_string = render_to_string :partial => dialog_content
      respond_to do |format|
        format.js{ render "application/model_dialog"}
      end
    end

    def render_message(message)
      respond_to do |format|
          format.js{ render "message_box", :locals=>{:message=>message}}
      end
    end

    def is_from_system_domain?
      #consider localhost?
      request.host.end_with?  Site.system_top_domain
    end

  end

end
