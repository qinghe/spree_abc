module Spree
  module Admin
    module PageLayoutsHelper
      def section_contexts_for_options
        (Spree::PageLayout::ContextEnum.members-[:either]).collect{|section_context| [Spree.t("section_context.#{ section_context }"), section_context] }
      end 
    end
  end
end
