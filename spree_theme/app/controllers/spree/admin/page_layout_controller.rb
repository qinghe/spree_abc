module Spree
  module Admin
    class PageLayoutController< ResourceController
      respond_to :html, :js
        def update_resource
          
          @theme = TemplateTheme.find( params[:template_theme_id])          
          assigned_resource_ids = params[:assigned_resource_ids].try(:[], @page_layout.id.to_s)
          #assign taxon
          section_piece_with_resources = @page_layout.section_pieces.with_resources.first
          if assigned_resource_ids.kind_of? Array
            if section_piece_with_resources.present?
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
            else# assigned taxon root or specific taxon
              assigned_resource_ids.each_with_index{|resource_id, index|
                resource_id = resource_id.to_i
                if resource_id>0
                  resource = SpreeTheme.taxon_class.find resource_id
                  if resource.root?
                    @theme.assign_resource(resource, @page_layout, index)                    
                  else
                    resource = Spree::SpecificTaxon.find resource_id
                    @theme.assign_resource(resource, @page_layout, index)    
                  end
                  
                else
                  @theme.unassign_resource(resource_class, @page_layout, index)
                end           
              }
            end
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
        def config_resource
          @template_theme = TemplateTheme.find( params[:template_theme_id] )
          
        end
    end
  end
end