module Spree
  module AssignedResource
    class DataSourceBasedResource
      attr_accessor :page_layout

      def initialize( page_layout )
        self.page_layout = page_layout
      end

      def resource_class
        case self.page_layout.current_data_source
        when Spree::PageLayout::DataSourceEnum.related_products
          Spree::RelationType
        else
          nil
        end
      end

    end
  end
end
