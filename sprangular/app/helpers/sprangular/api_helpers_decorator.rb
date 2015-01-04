module Spree
  module Api
    module ApiHelpers
      def taxon_attributes
        extra_attributes = [:description]
        if @@taxon_attributes.include?( extra_attributes.first )
          @@taxon_attributes
        else
          @@taxon_attributes + extra_attributes
        end
      end
    end
  end
end