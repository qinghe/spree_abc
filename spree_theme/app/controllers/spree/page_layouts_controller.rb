module Spree
  class PageLayoutsController < Spree::StoreController
    
    def edit
      @template_theme = TemplateTheme.find( params[:template_theme_id] )
      @page_layout = PageLayout.find( params[:id] )
      
      respond_to do |format|
        format.js{ render "application/dialog_for_editor"}
      end
      
    end
    
    def update
      @template_theme = TemplateTheme.find( params[:template_theme_id] )
      @page_layout = PageLayout.find( params[:id] )
      
      if @page_layout.update_attributes( permitted_resource_attributes )
        respond_with(@page_layout) do |format|
          format.js   { render :layout => false }
        end
      else
        respond_with(@page_layout) do |format|
          format.js { render layout: false }
        end
      end
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
    
    def permitted_resource_attributes
      params.require('page_layout').permit( permitted_attributes.page_layout_attributes )
    end
    
  end

end