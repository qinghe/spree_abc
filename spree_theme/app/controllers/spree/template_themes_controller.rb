module Spree
  class TemplateThemesController < Spree::StoreController
    helper 'spree/products'
    before_filter :add_view_path
    delegate :taxon_class,:site_class, :to=>:"SpreeTheme"

    def page
      #if SpreeTheme.site_class.current.dalianshops?
      #  redirect_to new_site_path      
      #end
    end  
    
    def under_construction  
      #logger.debug "request.env[/devise/]= #{request.env['devise.mapping']},#{warden.inspect}"   
      #require spree_auth_devise
      render "under_construction", layout:"under_construction"            
    end
    
    def new_admin_session
      
    end
    
    def create_admin_session
      user_params = params[:spree_user]
      user = Spree.user_class.find_for_authentication(:email => user_params[:email])
      if user.present?
        if user.valid_password?(user_params[:password])
          sign_in :spree_user,user 
        end 
      end
      if spree_user_signed_in? and current_spree_user.admin?
        redirect_to "/admin"
      else
        render "new_admin_session", layout:"under_construction"
      end
    end
    
    
    # GET /themes/1
    # GET /themes/1.xml
    def show
      @theme = TemplateTheme.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @theme }
      end
    end
  
  
    # GET /themes/1/edit
    def edit
      @theme = TemplateTheme.find(params[:id])
    end
  
    # PUT /themes/1
    # PUT /themes/1.xml
    def update
      @theme = TemplateTheme.find(params[:id])
  
      respond_to do |format|
        if @theme.update_attributes(params[:theme])
          format.html { redirect_to(@theme, :notice => 'TemplateTheme was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
        end
      end
    end
      
    
    # params for preview
    #    d: domain of website
    #    c: menu_id
    def preview
     
    #  @lg = PageGenerator.previewer( @menu, @theme, {:resource=>(@resource.nil? ? nil:@resource),:controller=>self})
    #  html = @lg.generate
    #  css,js  = @lg.generate_assets        
      #insert css to html
    #  style = %Q!<style type="text/css">#{css}</style>!
      #editor_panel require @theme, @editors, @editor ...
    #  html.insert(html.index("</head>"),style)
    #  html.insert(html.index("</body>"),@editor_panel)
    #  respond_to do |format|
    #    format.html {render :text => html}
    #  end
          
    end
          
    def assign_default
      website_params = params[:website]
      self.website[:index_page] = website_params[:index_page].to_i
      self.website.save
      render_message("yes, updated!")    
      
    end
    
    def assign
      # "commit"=>[Update&Preview|Update|Preview]
      commit_command = params[:commit]
      keys = params.keys.select{|k|k=~/menu[\d]+/}
      menus_params = params.values_at(*keys)
      
      if commit_command=~/Update/
        #update default page
        website_params = params[:website]
        self.site_class.current.attributes = website_params
        self.site_class.current.save
      end
      
      if commit_command=~/Publish/
        do_publish
      end
      
      respond_to do |format|
        format.js  {
          if commit_command=~/Preview/
            render "preview"          
          else# commit_command=~/Publish/
            render_message("yes, publish")
          end    
        }
      end   
  
    end
    
    def select_tree
      @menu = taxon_class.find(params[:menu_id])
      render :partial=>"menu_and_template"
    end
    
    def edit_layout
      
    end
      
    def editor
      theme_id = 0
      layout_id = 0
      theme = TemplateTheme.find(params[:id])
      prepare_params_for_editors(theme)
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
      @selected_page_layout = @theme.page_layout.self_and_descendants.find(selected_page_layout_id)
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
      @theme.page_layout.reload #layout is changed
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
  
    #FIXME, fix do_update_param_value
    def update_param_values
      selected_theme_id = params[:selected_theme_id]
      selected_editor_id = params[:selected_editor_id]
      param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}
      
      for pvk in param_value_keys
        param_value_params = params[pvk]
        pv_id = pvk[/\d+/].to_i
        param_value = ParamValue.find(pv_id, :include=>[:section_param, :section])
        do_update_param_value(param_value, param_value_params) 
      end
      
    end
    
    def update_param_value
      param_value_event = params[:param_value_event]
      editing_param_value_id = params[:editing_param_value_id].to_i
      editing_html_attribute_id = params[:editing_html_attribute_id].to_i
      theme_id = params[:selected_theme_id]
      editor_id = params[:selected_editor_id]
      layout_id = params[:selected_page_layout_id]
      param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}
      
        param_value_params = params["pv#{editing_param_value_id}"]
        source_param_value = ParamValue.find(editing_param_value_id, :include=>[:section_param, :section])
        updated_html_attribute_values = do_update_param_value(source_param_value, param_value_params, param_value_event, editing_html_attribute_id)
  
      #  param_value = ParamValue.find(editing_param_value_id)
      theme = TemplateTheme.find(theme_id)  
      editor = Editor.find(editor_id)
      page_layout = PageLayout.find(layout_id) 
      prepare_params_for_editors(theme,editor,page_layout)
     
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
      @param_value = ParamValue.find(@param_value_id, :include=>[:section_param=>:section_piece_param])
      #@editor = @param_value.section_param.section_piece_param.editor
      if request.post?        
        #TODO replace same name of template file 
        uploaded_image = TemplateFile.new( params[:template_file] )
        if uploaded_image.valid?
          uploaded_image['theme_id']=@param_value.theme_id              
          if uploaded_image.save
                # update param value to selected uploaded image
                param_value_params={@html_attribute_id.to_s=>{"unset"=>"0", "pvalue0"=>uploaded_image.attachment_file_name, "psvalue0"=>"0i"}}
                param_value_event = ParamValue::EventEnum[:pv_changed]
                editing_html_attribute_id = @html_attribte_id
                @updated_html_attribute_values = do_update_param_value(@param_value, param_value_params, param_value_event, editing_html_attribute_id) 
                # get all param values by selected editor
                #@param_values = ParamValue.within_section(@param_value).within_editor(@editor)
                # update param value
                render :partial=>'after_upload_dialog' 
          end
        else
        end
      else
        @theme = TemplateTheme.find(@param_value.theme_id)
        model_dialog("File upload dialog",@dialog_content)    
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

  end

end