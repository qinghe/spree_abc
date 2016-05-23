module Spree
  module AssignedResource
    class SectionPieceResource
      attr_accessor :resource, :context

      def initialize( section_piece, resource_and_context  )

        self.resource, self.context = resource_and_context.split(':')

        self.context  = (self.context.present? ? self.context.to_sym : DefaultTaxon::ContextEnum.home)
      end


      def resource_class
        case self.resource
          when 'm'
            SpreeTheme.taxon_class
          when 't'
            Spree::TemplateText
          when 'i'
            Spree::TemplateFile
        end
      end

    end
  end
end
