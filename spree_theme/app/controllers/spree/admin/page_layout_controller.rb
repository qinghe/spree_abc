module Spree
  module Admin
    class PageLayoutController< ResourceController
      
        def update_config
          
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
    end
  end
end