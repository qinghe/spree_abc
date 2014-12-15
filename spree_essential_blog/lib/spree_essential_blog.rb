require 'spree_core'
require "spree_essentials"
require "acts-as-taggable-on"
require "spree_essential_blog/version"
require "spree_essential_blog/engine"
require "spree_essential_blog/search"

module SpreeEssentialBlog
  mattr_accessor :site_class, :taxon_class

  def self.tab
    { :label => "Posts", :route => :admin_posts }
  end
  
  def self.sub_tab
    [:posts, { :label => "spree.admin.tab.posts", :match_path => "/posts" }]
  end

  def self.taxon_class
    @@taxon_class ||= "Spree::Taxon"
    if @@taxon_class.is_a?(Class)
      raise "Spree.taxon_class MUST be a String object, not a Class object."
    elsif @@taxon_class.is_a?(String)
      @@taxon_class.constantize
    end
  end
      
end

SpreeEssentials.register :blog, SpreeEssentialBlog
