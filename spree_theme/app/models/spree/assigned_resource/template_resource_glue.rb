# this is parser for tempate_theme.assigned_resource_ids
# assigned_resource_ids, it is serialized_hash
#  { "10"=>{"spree/taxon"=>[1]},        # page_layout.id =>{ assigned_taxon_class_key=>[taxon.id]}
#    "3"=>{"spree/template_file"=>[1]}  # page_layout.id =>{ assigned_file_class_key=>[file.id]}
#  }
#
module Spree
  module AssignedResource
    module TemplateResourceGlue

      def template_resources
        resource_collection = []
        assigned_resource_ids.each_pair{|page_layout_key, resources|
          if resources.present?
            resources.each_pair{|resource_key, resource_ids|
              if resource_ids.present?
                resource_ids.each_with_index{|resource_id, i|
                  if resource_id > 0
                    resource_collection << Spree::AssignedResource::TemplateResource.new( self, page_layout_key, resource_key, resource_id, i )
                  end
                }
              end
            }
          end
        }
        resource_collection
      end

      def create_template_resource( page_layout, resource,  position=0  )
        Spree::AssignedResource::TemplateResource.new( self, get_page_layout_key( page_layout ), get_resource_class_key( resource.class ), resource.id, position ).save!
      end


      def get_resource_class_key( resource_class )
        # Spree::TemplateFile => "spree/template_file"
        resource_class.to_s.underscore
      end

      def get_page_layout_key( page_layout )
        page_layout.id.to_s
      end

      def template_resource_by_page_layout

      end

      #def resource_class( page_layout )
      #  section_piece_with_resource = page_layout.section_pieces.with_resources.first
      #end

      # get resources order by taxon/image/text,
      # return array of resources, nil may be contained
      def assigned_resources_by_page_layout( selected_page_layout = nil )
        template_resources.select{|template_resource|
          template_resource.page_layout_id==selected_page_layout.id
        }.collect(&:source)
      end

      # all resources used by this theme
      # return taxon roots/ images /texts,  if none assgined, return [nil] or []
      def assigned_resources( resource_class, selected_page_layout = nil )
        selected_page_layout ||= self.page_layout_root
        template_resources.select{|template_resource|
          template_resource.source_class ==  resource_class && template_resource.page_layout_id==selected_page_layout.id
        }.collect(&:source)
      end

      # get assigned menu by specified page_layout_id, page_tag required
      # params:
      #   resource_position: get first( position 0 ) of assigned resources by default
      #     logged_and_unlogged_menu required this feature
      def assigned_resource_id( resource_class, selected_page_layout = nil, resource_position=0 )
        template_resources.select{|template_resource|
          template_resource.source_class ==  resource_class && template_resource.page_layout_id==selected_page_layout.id && template_resource.position == resource_position
        }.first.to_i
      end

      # assign resource to page_layout node
      def assign_resource( resource, selected_page_layout = nil, resource_position = 0 )
        selected_page_layout ||= self.page_layout_root
        create_template_resource( selected_page_layout, resource, resource_position )
      end
      # unassign resource from page_layout node
      def unassign_resource( resource_class, selected_page_layout, resource_position = 0 )
        template_resources.select{|template_resource|
          template_resource.source_class ==  resource_class && template_resource.page_layout_id==selected_page_layout.id && template_resource.position == resource_position
        }.each(&:destroy!)

      end

      #clear assigned_resource from theme
      def unassign_resource_from_theme!( resource )
        template_resources.select{|template_resource|
          template_resource.source ==  resource
        }.each(&:destroy!)
      end

    end
  end
end
