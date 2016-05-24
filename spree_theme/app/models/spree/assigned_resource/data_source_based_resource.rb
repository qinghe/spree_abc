module Spree
  module AssignedResource
    class DataSourceBasedResource
      attr_accessor :page_layout

      def initialize( page_layout )
        self.page_layout = page_layout
      end

      def resource_class
        if page_layout.current_data_source ==  Spree::PageLayout::DataSourceEnum.related_products
          return Spree::RelationType
        end

        child_data_sources = page_layout.children.collect( &:current_data_source ).select( &:present? )

        if child_data_sources.include? Spree::PageLayout::DataSourceEnum.related_products
          return Spree::RelationType
        end

      end

    end
  end
end
