module PageTag
  # blog_posts is hash, cache all named blog_posts of current page.
  # key is data_source name, value is proper blog_posts_tag
  #      self.blog_posts_tags_cache = {}
  class Products < ModelCollection
    
    class WrappedProduct < WrappedModel
      self.accessable_attributes=[:id,:name,:description,:images,:variant_images,:has_variants?,:price_in, :price, :master, :currency, :variants_and_option_values, :grouped_option_values,:variants_for_option_value, :total_on_hand,:variant_options_hash,:product_customization_types ] 
      delegate *self.accessable_attributes, :to => :model
      
      #:model_name use by small_image
      def self.model_name
        Spree::Product.model_name
      end
      
      def product_properties
        self.model.product_properties.includes(:property)
      end
    end  
        
    def wrapped_models
      models.collect{|model|  WrappedProduct.new(self, model) }
    end

    # means the current select blog post in erubis context.
    #def current
    #  if @current.nil? and !self.page_generator.resource.nil?
    #    @current = WrappedProduct.new( self, page_generator.resource)
    #  end
    #  @current
    #end
     
  end
end