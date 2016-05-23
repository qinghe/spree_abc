module Spree
  module Admin
    class PageLayoutsController< ResourceController
        respond_to :html, :json, :js #update title required json

        def update_resource
          @template_theme = TemplateTheme.find( params[:template_theme_id])
          assigned_resource_ids = params[:assigned_resource_ids]
          #assigned_resource_ids could be ['']
          assigned_resource_ids.select!(&:present?) if assigned_resource_ids.kind_of? Array
          section_piece_resources = @page_layout.section_piece_resources
          data_source_based_resource = @page_layout.data_source_based_resources

          if assigned_resource_ids.present?
            if section_piece_resources.present?
              section_piece_resources.each_with_index{|section_resource,index|
                resource_id = assigned_resource_ids[index]
                resource = section_resource.resource_class.find resource_id
                @template_theme.assign_resource(resource, @page_layout, index)
              }
            elsif data_source_based_resource.present?
              resource_id = assigned_resource_ids.first
              resource = data_source_based_resource.resource_class.find resource_id
              @template_theme.assign_resource(resource, @page_layout)
            else# assigned taxon
              assigned_resource_ids = assigned_resource_ids.split(',') if assigned_resource_ids.kind_of? String
              assigned_resource_ids.each_with_index{|resource_id, index|
                resource = SpreeTheme.taxon_class.find resource_id
                @template_theme.assign_resource(resource, @page_layout, index)
              }
            end
          else #unassign resource
            if section_piece_resources.present?
              section_piece_resources.each_with_index{|section_resource,index|
                @template_theme.unassign_resource(section_resource.resource_class , @page_layout, index)
              }
            else
              @template_theme.unassign_resource(SpreeTheme.taxon_class, @page_layout)
            end
          end
          @assigned_resources = @template_theme.assigned_resources_by_page_layout( @page_layout )
        end

        #update section_context
        def update_context
          section_contexts = params[:section_contexts]
          specific_taxon_ids = params[:specific_taxon_ids]
          if section_contexts.present?
            @page_layout.update_section_context(section_contexts )
          else
            @page_layout.update_section_context( PageLayout::ContextEnum.either )
          end
          @template_theme = TemplateTheme.find( params[:template_theme_id])
          if specific_taxon_ids.present?
            @specific_taxons = Spree::SpecificTaxon.find specific_taxon_ids.split(',')
            @specific_taxons.each_with_index{|resource, index|
              @template_theme.assign_resource(resource, @page_layout, index)
            }
          else
            @specific_taxons = []
            @template_theme.assigned_resources(Spree::SpecificTaxon,@page_layout).each_with_index{|assigned_resource,index|
              if assigned_resource.present?
                @template_theme.unassign_resource(Spree::SpecificTaxon, @page_layout, index)
              end
            }
          end

        end

        #update datasource
        def update_data_source
          section_data_source = params[:section_data_source]
          if section_data_source.present?
            @page_layout.update_data_source(section_data_source.to_sym )
          else
            @page_layout.update_data_source( PageLayout::DataSourceEmpty )
          end
        end

        def update_other
          view_as_clickable = params[:view_as_clickable]
          @page_layout.update_content_param( {:view_as_clickable=>view_as_clickable} )
        end

        def config_resource
          @template_theme = TemplateTheme.find( params[:template_theme_id] )
        end

        def config_context
          @template_theme = TemplateTheme.find( params[:template_theme_id] )
        end

        def config_data_source
          @template_theme = TemplateTheme.find( params[:template_theme_id] )
        end

        def config_other
          @template_theme = TemplateTheme.find( params[:template_theme_id] )
        end

    end
  end
end
