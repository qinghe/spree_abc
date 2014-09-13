module Spree
  module Admin
    module BaseHelper
      def page_contexts_for_options
        options = []
        Spree::Taxon::PageContextEnum.each_pair{|sym, obj| 
          options<< [Spree.t("section_context.#{ sym }"), obj] 
        }
        options
      end
    end
  end
end