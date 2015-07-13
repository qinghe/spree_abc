require 'spree_core'
require 'spree_theme/engine'
require 'spree_theme/paper_clip_interpolate_site'
require 'spree_theme/system'
require 'spree_theme/site_helper'
require 'spree_theme/seed_helper'
require 'spree_theme/permitted_attributes_for_theme'
require 'spree_theme/simple_permalink'
require 'spree_theme/template_base_helper'
require 'spree_theme/client_info'

module SpreeTheme
  
  mattr_accessor :site_class, :taxon_class, :post_class

  def self.site_class
    @@site_class ||= "Spree::Site"
    if @@site_class.is_a?(Class)
      raise "Spree.site_class MUST be a String object, not a Class object."
    elsif @@site_class.is_a?(String)
      @@site_class.constantize
    end
  end
  
  
  def self.taxon_class
    @@taxon_class ||= "Spree::Taxon"
    if @@taxon_class.is_a?(Class)
      raise "Spree.taxon_class MUST be a String object, not a Class object."
    elsif @@taxon_class.is_a?(String)
      @@taxon_class.constantize
    end
  end

  def self.post_class
    @@post_class ||= "Spree::Post"
    if @@post_class.is_a?(Class)
      raise "Spree.post_class MUST be a String object, not a Class object."
    elsif @@post_class.is_a?(String)
      @@post_class.constantize
    end
  end
end
