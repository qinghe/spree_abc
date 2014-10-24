# this is parser for tempate_theme.assigned_resource_ids
# assigned_resource_ids, it is serialized_hash
#  { "10"=>{"spree/taxon"=>[1]},        # page_layout.id =>{ assigned_taxon_class_key=>[taxon.id]} 
#    "3"=>{"spree/template_file"=>[1]}  # page_layout.id =>{ assigned_file_class_key=>[file.id]}
#  } 
#

module Spree
  module AssignedResource
    module IdsHandler
      
      def get_assigned_resource_ids
        assigned_resource_ids
      end
      
      def get_all_assigned_resources
        
        key_and_class_map = {}
        SectionPiece.resource_classes.each{|resource_class|
          key_and_class_map[get_resource_class_key( resource_class )] = resource_class
        }
        assigned_resource_ids.each_pair{|page_layout_key, resources|
          if resources.present?
            resources.each_pair{|resource_key, resource_ids|
              resource_ids = resource_ids.uniq.select{|i| i>0 }
              if resource_ids.present?
                resource_class = key_and_class_map[resource_key]
                resource_collection.concat resource_class.unscoped.find( resource_ids )
              end
            }
          end
        }
        resource_collection
      end


      class HandlerImplement
        attr_accessor :new_assigned_resource_ids #{:key=>id}  key = :page_layout_id + resource_key + position
        attr_accessor :template_theme
        def initialize( template_theme)
          self.template_theme = template_theme
        end        
    
        def assigned_resources
          resource_collection = []
          assigned_resource_ids.each_pair{|page_layout_key, resources|
            if resources.present?
              resources.each_pair{|resource_key, resource_ids|                
                if resource_ids.present?
                  resource_ids.each_with_index{|resource_id, i|
                    if resource_id.to_i > 0
                      resource_collection.concat( Spree::TemplateResource.new(template_theme, page_layout_key, resource_key, resource_id, i ) )    
                    end
                  }
                end
              }
            end
          }
          resource_collection
        end
        
        # get resources order by taxon/image/text,  
        # return array of resources, no nil contained
        def assigned_resources_by_page_layout( page_layout )
          assigned_resources.select{|resource| resource.page_layout_id == page_layout.id}
        end
        
        # all resources used by this theme
        # return menu roots/ images /texts,  if none assgined, return [nil] or []
        def assigned_resources_by_page_layout_and_resource_class( resource_class, page_layout )

        end  
        
        # get assigned menu by specified page_layout_id
        # params:
        #   resource_position: get first( position 0 ) of assigned resources by default
        #     logged_and_unlogged_menu required this feature
        def assigned_resource_id( resource_class, page_layout, resource_position=0 )
          
        end    
        
      # unassign resource from page_layout node
      def unassign_resource( resource_class, page_layout, resource_position=0 )
        #assigned_resource_ids={page_layout_id={:menu_ids=>[]}}
        self.assigned_resource_ids = {} unless assigned_resource_ids.present?        
        resource_key = get_resource_class_key(resource_class)
        page_layout_key = get_page_layout_key page_layout
        self.assigned_resource_ids[page_layout_key]||={}
        self.assigned_resource_ids[page_layout_key][resource_key]||=[]
        self.assigned_resource_ids[page_layout_key][resource_key][resource_position] = 0
        self.save! 
      end

    
      end
      
    end
  end
end