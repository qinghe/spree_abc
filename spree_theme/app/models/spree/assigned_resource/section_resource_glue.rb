module Spree
  module AssignedResource
    module SectionResourceGlue

      def section_piece_resources
        section_piece_with_resources = self.section_pieces.with_resources.first
        if section_piece_with_resources.present?
          section_piece_with_resources.resource_strings.collect{|res_ctx|
            Spree::AssignedResource::SectionPieceResource.new( section_piece_with_resources, res_ctx )
          }
        else
          []
        end
      end

      def data_source_based_resources
        #''.present? => false
          case self.current_data_source
          when Spree::PageLayout::DataSourceEnum.related_products
              Spree::AssignedResource::DataSourceBasedResource.new( self )
            else
              nil
          end
      end

    end
  end
end
