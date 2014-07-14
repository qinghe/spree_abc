module PageTag
  class Menus < Base
    class WrappedMenu < WrappedModel
      self.accessable_attributes=[:id,:name,:icon,:page_home?,:depth, :leaf?]
      delegate *self.accessable_attributes, :to => :model
      delegate :taxonomy, :to => :model
      
      def children
        self.model.children.collect{|item| WrappedMenu.new(self.collection_tag, item)}
      end

      def descendants
        self.model.descendants.collect{|item| WrappedMenu.new(self.collection_tag, item)}
      end

      def ancestors
        self.model.ancestors.collect{|item| PageTag::Menus::WrappedMenu.new(self.collection_tag, item)}        
      end
          
      # url link to the menu itme's page(each menu itme link to a page).
      def current?
        self.collection_tag.template_tag.page_generator.menu.id == self.model.id
      end
      
      def clickable?
        true
      end
      
      #get current page's resource by template.current_piece 
      def resources()
        objs = []
        data_source = self.collection_tag.template_tag.current_piece.data_source
        if data_source.present?
          if data_source == 'gpvs'
            #objs = menu.products
            #copy from taxons_controller#show
            searcher = Spree::Config.searcher_class.new({:taxon => self.id})
            #@searcher.current_user = try_spree_current_user
            #@searcher.current_currency = current_currency
            objs = searcher.retrieve_products
          elsif data_source == 'this_product'
            #default_taxon.id is 0 
            objs = [self.resource] #menu.products.where(:id=>resource.id)        
          end
          if objs.present?
            objs = Products.new( self.collection_tag.page_generator, objs)
          end
        end
        objs
      end
            
    end
    attr_accessor :menus_cache #store all menus of template, key is page_layout_id, value is menu tree
    attr_accessor :template_tag, :page_generator
    #model.path require page_generator
    delegate :page_generator, :to=>:template_tag
    
    def initialize(template_tag)
      self.template_tag = template_tag
      self.menus_cache = {}
    end

    # get menu root assigned to section instance 
    # 1. containerA(menu) - taxonomy_name
    #                     - hmenu
    # 2. containerB- hmenu(menu)
    # for menu assignment easy, method 1 is not support any more   
    def get( wrapped_page_layout, resource_position=0  )
      key = wrapped_page_layout.to_key 
      unless menus_cache.key? key
        menu_tree = nil
        #wrapped_page_layout.assigned_menu_id may not exist for some reason.        
        assigned_menu_id = wrapped_page_layout.assigned_menu_id(resource_position)
        if assigned_menu_id>0 and SpreeTheme.taxon_class.exists?( assigned_menu_id )
          menu_tree = SpreeTheme.taxon_class.find( assigned_menu_id ).self_and_descendants
        end
        menus_cache[key] = menu_tree     
      end
      
      if menus_cache[key].blank?
        # get default menu
        if wrapped_page_layout.section.present?
          wrapped_resource = wrapped_page_layout.section.section_piece.wrapped_resources[resource_position]
          if wrapped_resource.present?
            menus_cache[key] = DefaultTaxonRoot.instance_by_context( wrapped_resource.context ).self_and_descendants
          end
        end
      end
      
      if menus_cache[key].present?
        WrappedMenu.new( self, menus_cache[key].first)
      else        
        nil  
      end
    end
    
    def menu( resource_position=0 )
      get( template_tag.current_piece,  resource_position )
    end
    
    def menu2
      get( template_tag.current_piece,  1 )
    end
          
  end
end
