
module PageTag
  class RelatedProducts < Products

    attr_accessor :wrapped_product

    def initialize(page_generator_instance, models, wrapped_taxon, wrapped_product)
      super(page_generator_instance, models, wrapped_taxon)
      self.wrapped_product = wrapped_product
    end
  end
end
