# this is parser for tempate_theme.assigned_resource_ids
# assigned_resource_ids, it is serialized_hash
#  { "10"=>{"spree/taxon"=>[1]},        # page_layout.id =>{ assigned_taxon_class_key=>[taxon.id]} 
#    "3"=>{"spree/template_file"=>[1]}  # page_layout.id =>{ assigned_file_class_key=>[file.id]}
#  } 
#

module Spree
  module AssignedResource
    module IdsHandler
           
      def template_resources
        resource_collection = []
        assigned_resource_ids.each_pair{|page_layout_key, resources|
          if resources.present?
            resources.each_pair{|resource_key, resource_ids|                
              if resource_ids.present?
                resource_ids.each_with_index{|resource_id, i|
                  if resource_id > 0 
                    resource_collection << Spree::TemplateResource.new( self, page_layout_key, resource_key, resource_id, i )     
                  end
                }
              end
            }
          end
        }
        resource_collection
      end

      def create_template_resource( page_layout, resource,  position=0  )
        Spree::TemplateResource.new( self, get_page_layout_key( page_layout ), get_resource_class_key( resource.class ), resource.id, position ).save!
      end
    
           
      def get_resource_class_key( resource_class )
        # Spree::TemplateFile => "spree/template_file"
        resource_class.to_s.underscore
      end
      
      def get_page_layout_key( page_layout )
        page_layout.id.to_s
      end 
  
    end
  end
end