SpreeTheme.taxon_class.class_eval do
    include Spree::Context::Taxon
    include Spree::AssignedResource::SourceInterface

    before_destroy :remove_from_theme
    before_validation :set_default_values
    #for resource_class.resourceful
    scope :resourceful,->(theme){ roots }

    belongs_to :replacer, class_name: 'Spree::Taxon', foreign_key: 'replaced_by'
    serialize :html_attributes, Hash
    #attr_accessible :page_context, :replaced_by, :is_clickable

    alias_attribute :extra_html_attributes, :html_attributes

    def summary( truncate_at=100)
      #copy from Action View Sanitize Helpers
      HTML::FullSanitizer.new.sanitize( description || '' ).truncate( truncate_at )
    end

    def remove_from_theme
      Spree::TemplateTheme.native.each{|theme|
        theme.unassign_resource_from_theme! self
      }
    end

    # it is resource of template_theme
    def importable?
      root?
    end

    # taxon is from other site
    def self.find_or_copy( taxon )
      raise "only support taxon root" unless taxon.root?

      existing_taxon = roots.find_by_permalink( taxon.permalink )
      if existing_taxon.blank?
        cloned_branch = taxon.clone_branch(  )
        cloned_branch.save!
      end
      existing_taxon||cloned_branch
    end

    #copy self into current site
    def clone_branch(  )
      #raise "only copy taxon from design site" unless taxon.site.design?
      #raise "taxon exists in current site" if self.class.exists(:permalink=>self.permalink)
      cloned_branch = nil
        self.site.tap{|site|
          original_current_site = Spree::Site.current
          Spree::Site.current = site
            #copy from http://stackoverflow.com/questions/866528/how-to-best-copy-clone-an-entire-nested-set-from-a-root-element-down-with-new-tr
            new_taxonomy = self.taxonomy.dup
            # should not save new_taxonomy here, or new_taxonomy.root.site_id is not current site id
            h = { self => self.dup } #we start at the root
            ordered = self.descendants
            #clone subitems
            ordered.each do |item|
              h[item] = item.dup
            end
            #resolve relations
            ordered.each do |item|
              cloned = h[item]
              item_parent = h[item.parent]
              item_parent.children << cloned if item_parent
              # handle icon
            end
            h.values.each{|cloned|
              cloned.site = original_current_site
              cloned.taxonomy = new_taxonomy
            }
            new_taxonomy.site = original_current_site
            new_taxonomy.root = h[self]
            cloned_branch = h[self]
          Spree::Site.current = original_current_site
        }
        cloned_branch
    end

    #deep dup, include icon
    def dup
      original_dup = super
      original_dup.icon = self.icon
      original_dup
    end

    #strange,  Mysql2::Error: Column 'page_context' cannot be null: UPDATE `spree_taxons` SET `html_attributes` = '--- {}\n', `page_context` = NULL, `replaced_by` = 491, `updated_at` = '2015-04-08 12:51:34' WHERE `spree_taxons`.`id` = 460
    #"taxon"=>{"name"=>"新闻中心", "replaced_by"=>"491", "page_context"=>"", "is_clickable"=>"1", "description"=>"", "meta_title"=>"", "meta_description"=>"", "meta_keywords"=>""},
    # so set page_context 0 here if it is empty?
    def set_default_values
      self.page_context = 0 if page_context.blank?
      self.replaced_by = 0 if replaced_by.blank?
    end

    def stylish_with_inherited
      return self.stylish if self.stylish>0
      return root.stylish
    end
end
