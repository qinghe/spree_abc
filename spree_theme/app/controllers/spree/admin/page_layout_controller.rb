module Spree
  module Admin
    class PageLayoutController< ResourceController
      respond_to :html, :js
      
        def update_resource
          
          @theme = TemplateTheme.find( params[:template_theme_id])          
          assigned_resource_ids = params[:assigned_resource_ids].try(:[], @page_layout.id.to_s)
          #assign taxon
          section_piece = @page_layout.section_pieces.with_resources.first
          if assigned_resource_ids.kind_of? Array
            section_piece.wrapped_resources.each_with_index{|wrapped_resource,index|
              resource_id = assigned_resource_ids[index].to_i
              resource_class = wrapped_resource.resource_class               
              if resource_id>0
                resource = resource_class.find resource_id
                @theme.assign_resource(resource, @page_layout, index)
              else
                @theme.unassign_resource(resource_class, @page_layout, index)
              end              
            }
          end
          respond_to do |format|
            format.js  { render :text => 'Ok' }
          end         
        end
        
        #update section_context
        def update_context
          
        end
        
        #update datasource
        def update_data_source
          
        end
        
        # copy from backend/app/controllers/spree/resource_controller.rb        
        def update
          invoke_callbacks(:update, :before)
          if @object.update_attributes(params[object_name])
            invoke_callbacks(:update, :after)
            flash[:success] = flash_message_for(@object, :successfully_updated)
            respond_with(@object) do |format|
              format.html { redirect_to location_after_save }
              #format.js   { render :layout => false }
              format.js   { render :text=>@object.to_json }
            end
          else
            invoke_callbacks(:update, :fails)
            respond_with(@object)
          end
        end

    end
  end
end