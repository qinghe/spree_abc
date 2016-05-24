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
        # self/children  data_source include? Spree::PageLayout::DataSourceEnum.related_products
        # we have to consider children's data_source, for feature  relation_type.name
        if self.current_data_source ==  Spree::PageLayout::DataSourceEnum.related_products
          return Spree::AssignedResource::DataSourceBasedResource.new( self )
        end

        child_data_sources = self.children.collect( &:current_data_source ).select( &:present? )

        if child_data_sources.include? Spree::PageLayout::DataSourceEnum.related_products
          return Spree::AssignedResource::DataSourceBasedResource.new( self )
        end

      end

    end
  end
end
