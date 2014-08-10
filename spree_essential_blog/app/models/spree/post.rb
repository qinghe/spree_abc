module Spree
  class Post < ActiveRecord::Base
    
    attr_accessible :blog_id, :title, :teaser, :body, :posted_at, :author, :live, :tag_list, :taxon_ids, :product_ids_string
    
    acts_as_taggable
  
    # for flash messages    
    alias_attribute :name, :title
    
    has_and_belongs_to_many :taxons, :join_table => "spree_posts_taxons", :class_name => "Spree::Taxon"
    alias_attribute :categories, :taxons
    
    #belongs_to :blog, :class_name => "Spree::Taxon"
    #has_many :taxons, :dependent => :destroy
    has_many :products, :through => :post_products
    
    #validates :blog_id, :title, :presence => true
    validates :permalink,  :presence => true, :uniqueness => true, :if => proc{ |record| !record.title.blank? }
    validates :body,  :presence => true
    validates :posted_at, :datetime => true
    
    cattr_reader :per_page
    @@per_page = 10
  
    scope :ordered, order("posted_at DESC")
    scope :future,  where("posted_at > ?", Time.now).order("posted_at ASC")
    scope :past,    where("posted_at <= ?", Time.now).ordered
    scope :live,    where(:live => true )
  
   	before_validation :create_permalink, :if => proc{ |record| record.title_changed? }
    
    # add search related
    cattr_accessor :searcher_class do
      SpreeEssentialBlog::Search
    end
    cattr_accessor :search_scopes do
      []
    end
  
    def self.add_search_scope(name, &block)
      self.singleton_class.send(:define_method, name.to_sym, &block)
      search_scopes << name.to_sym
    end
    #copy from spree/core/model/product/scope
    add_search_scope :in_taxon do |taxon|
      select("spree_posts.id, spree_posts.*").
      where(id: PostClassification.select('spree_posts_taxons.post_id').
            joins(:taxon).
            where( Taxon.table_name => { :id => taxon.self_and_descendants.pluck(:id) })
           )
    end
    # end search 
    
    # Creates date-part accessors for the posted_at timestamp for grouping purposes.
    %w(day month year).each do |method|
      define_method method do
        self.posted_at.send(method)
      end
    end
    
    # all post belongs to taxon which context is blog, in this way, we cuold list all post of website. ex. page blogs list recent posts  
    def taxon
      
    end
    
    alias_method :blog, :taxon
    	
  	def rendered_preview
      preview = body.split("<!-- more -->")[0]
      render(preview)
    end
  	
  	def rendered_body
  	  render(body.gsub("<!-- more -->", ""))
    end
  		
  	def preview_image
      images.first if has_images?	  
  	end
  
    def has_images?
      images && !images.empty?
    end
    
  
    def live?
      live && live == true
    end
  
    def to_param
  		permalink
  	end
  	
    def product_ids_string
      product_ids.join(',')
    end
  
    def product_ids_string=(s)
      self.product_ids = s.to_s.split(',').map(&:strip)
    end
    
  	private
  			
      def create_permalink
    		count = 2
    		new_permalink = title.to_s.parameterize
    		exists = permalink_exists?(new_permalink)
    		while exists do
    			dupe_permalink = "#{new_permalink}-#{count}"
    			exists = permalink_exists?(dupe_permalink)
    			count += 1
    		end
    		self.permalink = dupe_permalink || new_permalink
    	end
    	
    	def permalink_exists?(new_permalink)
    		post = Spree::Post.find_by_permalink(new_permalink)
    		post != nil && !(post == self)
    	end  	
  end
  
end