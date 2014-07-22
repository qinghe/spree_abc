module Spree
  module Admin
    class PageLayoutController< ResourceController
        respond_to :html, :js

        def update_resource          
          @template_theme = TemplateTheme.find( params[:template_theme_id])          
          assigned_resource_ids = params[:assigned_resource_ids]
          section_piece_with_resources = @page_layout.section_pieces.with_resources.first
          if assigned_resource_ids.present?
            if section_piece_with_resources.present?
              section_piece_with_resources.wrapped_resources.each_with_index{|wrapped_resource,index|
                resource_id = assigned_resource_ids[index]
                resource = wrapped_resource.resource_class.find resource_id
                @template_theme.assign_resource(resource, @page_layout, index)
              }
            else# assigned taxon root
              assigned_resource_ids.each_with_index{|resource_id, index|
                resource = SpreeTheme.taxon_class.find resource_id
                @template_theme.assign_resource(resource, @page_layout, index)                    
              }
            end
          else #unassign resource
            if section_piece_with_resources.present?
              section_piece_with_resources.wrapped_resources.each_with_index{|wrapped_resource,index|
                @template_theme.unassign_resource(wrapped_resource.resource_class , @page_layout, index)
              }
            else
              @template_theme.unassign_resource(SpreeTheme.taxon_class, @page_layout)                
            end
          end          
          @assigned_resources = @template_theme.assigned_resources_by_page_layout( @page_layout )          
        end
        
        #update section_context
        def update_context
          
        end
        
        #update datasource
        def update_data_source
          
        end
        
        # copy from backend/app/controllers/spree/resource_controller.rb        
        def config_resource
          @template_theme = TemplateTheme.find( params[:template_theme_id] )          
        end
        
        def config_context
          @template_theme = TemplateTheme.find( params[:template_theme_id] )
        end
    end
  end
end