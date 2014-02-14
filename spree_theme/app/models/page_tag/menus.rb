module PageTag
  class Menus < Base
    class WrappedMenu < WrappedModel
      self.accessable_attributes=[:id,:name]
      delegate *self.accessable_attributes, :to => :model
      delegate :taxonomy, :to => :model
      
      def children
        self.model.children.collect{|item| WrappedMenu.new(self.collection_tag, item)}
      end
          
      # url link to the menu itme's page(each menu itme link to a page).
      def current?
        self.collection_tag.template_tag.page_generator.menu.id == self.model.id
      end
      
      def clickable?
        true
      end
      
      #override super, menu belongs to template
      def path
        self.collection_tag.template_tag.page_generator.build_path( self.model)
      end
    end
    attr_accessor :menus_cache #store all menus of template, key is page_layout_id, value is menu tree
    attr_accessor :template_tag
    
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
        if wrapped_page_layout.section_piece.present?
          wrapped_resource = wrapped_page_layout.section_piece.wrapped_resources[resource_position]
            if wrapped_resource.present?
              menus_cache[key] = DefaultTaxon.instance_by_context( wrapped_resource.context ).self_and_descendants
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
      
    def menus
      if self.collection_tags.nil?
        self.menu_models = []
        param_values =  ParamValue.find(:all,:conditions=>["layout_root_id=? and theme_id=? and param_values.section_id=? and param_values.section_instance=? and section_piece_params.pclass=?", 
          page_generator.layout_id, page_generator.theme_id, self.section['section_id'], self.section['section_instance'], 'db'],
            :include=>[:section_param=>:section_piece_param]
          )
        for pv in param_values
          menu_root_ids = pv.html_attribute_values_hash.values.collect{|hav| hav.pvalue}
          menu_roots = SpreeTheme.taxon_class.find(:all, :conditions=>["id in (?)",menu_root_ids])
          
          self.menu_models = menu_roots.collect{|menu| WrappedMenu.new(self, menu)} 
          self.menu_keys = pv.html_attribute_values_hash.values.collect{|hav| hav.html_attribute['slug']}
        end
      end
      self.menu_models
    end
    
    def menus_hash
      menus.each_index.inject({}){|h,i|h[self.menu_keys[i]] = self.menu_models[i]}
    end
  end
end
