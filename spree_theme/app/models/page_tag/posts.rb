module PageTag
  # blog_posts is hash, cache all named blog_posts of current page.
  # key is data_source name, value is proper blog_posts_tag
  #      self.blog_posts_tags_cache = {}
  class Posts < ModelCollection
    
    class WrappedPost < WrappedModel
      self.accessable_attributes=[:id, :title, :body, :posted_at, :cover]
      delegate *self.accessable_attributes, :to => :model
      
      
      def path
        "/post"+ collection_tag.wrapped_taxon.path + "/#{model.id}-#{model.permalink}"
      end     
    end  
    
    
    def wrapped_models
      models.collect{|model|  WrappedPost.new(self, model) }
    end
        

    # means the current select blog post in erubis context.
    def current
      if @current.nil? and !self.page_generator.resource.nil?
        @current = WrappedPost.new( self, page_generator.resource)
      end
      @current
    end
     
  end
end