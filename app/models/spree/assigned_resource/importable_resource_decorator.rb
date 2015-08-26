# all Assignable source should implement source interface
module Spree
  module AssignedResource
    module ImportableResource
      def importable?
        raise "please implement it as template source"
      end
      module ClassMethods
        def find_or_copy
          raise "please implement it as template source"
        end
      end
    end
  end
end


Spree::SpecificTaxon.class_eval do
  include Spree::AssignedResource::ImportableResource

  # it is resource of template_theme
  def importable?
    false
  end
end

Spree::Taxon.class_eval do
  include Spree::AssignedResource::ImportableResource
    # it is resource of template_theme
    def importable?
      root?
    end

    # we have to define it in spree_multi_size, it requires Spree::MultiSiteSystem
    # * usage - find existing taxon by taxon.permalink in current site,
    # *   if can not found, clone whole taxonomy
    # * params
    #   * taxon - taxon root, usually taxon is from other site
    #
    def self.find_or_copy( taxon )
      raise "only support taxon root" unless taxon.root?

      existing_taxon = roots.find_by_permalink( taxon.permalink )
      cloned_branch = nil
      if existing_taxon.blank?
        cloned_branch = taxon.clone_branch(  )
        cloned_branch.save!
      end
      existing_taxon||cloned_branch
    end

    # copy self into current site
    def clone_branch(  )
      raise "only support taxon root" unless self.root?
      #raise "only copy taxon from design site" unless taxon.site.design?
      #raise "taxon exists in current site" if self.class.exists(:permalink=>self.permalink)
      cloned_branch = nil
      current_site_id = Spree::Site.current.id
      #maybe clone taxon from other site
      Spree::MultiSiteSystem.with_context_free_taxon{
            #copy from http://stackoverflow.com/questions/866528/how-to-best-copy-clone-an-entire-nested-set-from-a-root-element-down-with-new-tr
            new_taxonomy = self.taxonomy.dup
            new_taxonomy.site_id = current_site_id
            # should not save new_taxonomy here, or new_taxonomy.root.site_id is not current site id
            h = { self => self.duplicate } #we start at the root
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
              cloned.site_id = new_taxonomy.site_id
              cloned.taxonomy = new_taxonomy
            }
            new_taxonomy.root = h[self]
            cloned_branch = h[self]
        }
        cloned_branch
    end

    #deep dup, include icon
    def duplicate
      # do not use this.dup, do not bother lft,rgt
      taxon = self.class.new
      taxon.attributes = self.attributes.except('id', 'parent_id', 'lft', 'rgt','depth', 'replaced_by')
      taxon.icon = self.icon
      taxon
    end

end

Spree::TemplateText.class_eval do
  include Spree::AssignedResource::ImportableResource
  # it is resource of template_theme
  def importable?
    true
  end

  def self.find_or_copy( text )
    existing_text = find_by_permalink( text.permalink )
    if existing_text.blank?
      cloned_branch = text.dup
      cloned_branch.site_id = Spree::Site.current.id
      cloned_branch.save!
    end
    existing_text||cloned_branch
  end
end

Spree::TemplateFile.class_eval do
  include Spree::AssignedResource::ImportableResource
  # it is resource of template_theme
  def importable?
    false
  end
end
