# all Assignable source should implement source interface
module Spree
  module AssignedResource
    module SourceInterface
      def find_or_copy
        raise "please implement it as template source"
      end
      def importable?
        raise "please implement it as template source"
      end
    end
  end
end
           