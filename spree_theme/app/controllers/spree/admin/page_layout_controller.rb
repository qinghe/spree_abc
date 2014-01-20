module Spree
  module Admin
    class PageLayoutController< ResourceController
      
        def update_config
          
          @theme = TemplateTheme.find( params[:template_theme_id])          
          assigned_resource_ids = params[:assigned_resource_ids].try(:[], @page_layout.id.to_s)
          #assign taxon
          if assigned_resource_ids.kind_of? Array
            assigned_resource_ids.each_with_index{|taxon_id, index|
              if taxon_id.to_i>0
                taxon = SpreeTheme.taxon_class.find taxon_id
                @theme.assign_resource(taxon, @page_layout, index)
              else
                @theme.unassign_resource(SpreeTheme.taxon_class, @page_layout, index)
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