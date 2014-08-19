module PageTag
  class ModelCollection < Base
    include Enumerable
    class_attribute :accessable_attributes
    self.accessable_attributes=[:num_pages] 
    delegate *self.accessable_attributes, :to => :models

    attr_accessor :models

    
    def initialize(page_generator_instance, models)
      super(page_generator_instance)
      @models = models
    end

    def wrapped_models
      raise 'not implement'  
    end
    
        
    def each(&block)
      self.wrapped_models.each{|item|
        yield item
      }
      self
    end
  end
end
