module PageTag
  class Menus < Base
    class WrappedMenu < WrappedModel
      self.accessable_attributes=[:id, :name, :icon, :summary, :path, :friendly_id, :tooltips, :is_clickable?, :home?,:depth, :leaf?,:root?,:persisted?, :extra_html_attributes, :description, :replaced_by ]
      delegate *self.accessable_attributes, :to => :model
      delegate :taxonomy, :root, :to => :model

      def children
        self.model.children.collect{|item| WrappedMenu.new(self.collection_tag, item)}
      end

      def descendants
        self.model.descendants.collect{|item| WrappedMenu.new(self.collection_tag, item)}
      end

      def ancestors
        self.model.ancestors.collect{|item| PageTag::Menus::WrappedMenu.new(self.collection_tag, item)}
      end

      def ancestor_ids
        if @ancestor_ids.nil?
          @ancestor_ids = self.model.ancestors.map(&:id)
        end
        @ancestor_ids
      end

      # url link to the menu itme's page(each menu itme link to a page).
      def current?
        (self.collection_tag.template_tag.page_generator.menu.id == self.model.id) || (self.collection_tag.template_tag.page_generator.menu.id == self.model.replaced_by)
      end

      def clickable?
        is_clickable?
      end

      # template.products replace it.
      #get current page's resource by template.current_piece
      #def resources()
      #  objs = []
      #  data_source = self.collection_tag.template_tag.current_piece.data_source
      #  if data_source.present?
      #    if data_source == 'gpvs'
      #      #objs = menu.products
      #      #copy from taxons_controller#show
      #      searcher = Spree::Config.searcher_class.new({:taxon => self.id})
      #      objs = searcher.retrieve_products
      #    elsif data_source == 'this_product'
      #      #default_taxon.id is 0
      #      objs = [self.resource] #menu.products.where(:id=>resource.id)
      #    elsif data_source == 'gpvs_theme'
      #        objs = Spree::MultiSiteSystem.with_context_site1_themes{
      #          searcher = Spree::Config.searcher_class.new({:taxon => self.id})
      #          searcher.retrieve_products.where('spree_products.theme_id>0')
      #        }
      #    end
      #    if objs.present?
      #      objs = Products.new( self.collection_tag.page_generator, objs)
      #    end
      #  end
      #  objs
      #end

      def partial_path
        # menu.id would be nil if it is class DefaultTaxon
        if( model.persisted? && !model.home? )
          path
        else
          # in case default home page show all products,
          # to prevent '//10-cup', it is required
          "/#{self.model.id.to_i}"
        end
      end

      def resource_taxon_id
        replaced_by > 0 ? replaced_by : id
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
    # 1. containerA(taxon_root) - taxonomy_name
    #                           - hmenu
    # 2. containerB- hmenu( taxon_root )
    # 3. containerC- taxon_name( taxon )
    #              - container( taxon.products )
    #                - product_name
    # for menu assignment easy, method 1 is not support any more
    def get( wrapped_page_layout, resource_position=0  )
      key = wrapped_page_layout.to_key
      menu_tree = nil
      unless menus_cache.key? key
        #wrapped_page_layout.assigned_menu_id may not exist for some reason.
        assigned_menu_id = wrapped_page_layout.assigned_menu_id(resource_position)
        if assigned_menu_id>0 && SpreeTheme.taxon_class.exists?( assigned_menu_id )
          menu_tree = SpreeTheme.taxon_class.find( assigned_menu_id ).self_and_descendants
        end
        menus_cache[key] = menu_tree
      end

      if menus_cache[key].blank?
        # get default menu, with_resources may return [] since support assign resource to container.
        section_with_resources = wrapped_page_layout.section_pieces.with_resources.first
        if section_with_resources && section_with_resources.wrapped_resources[resource_position]
          wrapped_resource  = section_with_resources.wrapped_resources[resource_position]
          menus_cache[key] = DefaultTaxonRoot.instance_by_context( wrapped_resource.context ).self_and_descendants
        end
      end
      Rails.logger.debug "wrapped_page_layout=#{key}#{wrapped_page_layout.title}, menu_tree=#{menu_tree.inspect}"
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
