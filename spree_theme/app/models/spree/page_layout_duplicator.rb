# mainly it is nested set duplicator
module Spree
  class PageLayoutDuplicator
    attr_accessor :page_layout_root
    def initialize( page_layout_root)
      self.page_layout_root = page_layout_root
    end

    def duplicate
      h = { page_layout_root => page_layout_root.dup } #we start at the root
      ordered = page_layout_root.descendants
      #clone subitems
      ordered.each do |item|
        h[item] = item.dup
      end
      #resolve relations
      ordered.each do |item|
        cloned = h[item]
        item_parent = h[item.parent]
        item_parent.children << cloned if item_parent
      end
      h.values.each{|cloned|
        cloned.site_id = SpreeTheme.site_class.current.id
      }
      cloned_branch = h[page_layout_root]
    end
  end
end
