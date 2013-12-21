require 'spree_core'
require 'spree_theme/engine'
require 'spree_theme/system'
require 'spree_theme/site_helper'
require 'spree_theme/section_piece_param_helper'

module SpreeTheme
  
  mattr_accessor :site_class, :taxon_class

  def self.site_class
    if @@site_class.is_a?(Class)
      raise "Spree.site_class MUST be a String object, not a Class object."
    elsif @@site_class.is_a?(String)
      @@site_class.constantize
    end
  end
  
  
  def self.taxon_class
    if @@taxon_class.is_a?(Class)
      raise "Spree.taxon_class MUST be a String object, not a Class object."
    elsif @@taxon_class.is_a?(String)
      @@taxon_class.constantize
    end
  end
end
