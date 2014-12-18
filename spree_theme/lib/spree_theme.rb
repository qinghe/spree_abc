require 'spree_core'
require 'spree_theme/engine'
require 'spree_theme/paper_clip_interpolate_site'
require 'spree_theme/system'
require 'spree_theme/site_helper'
require 'spree_theme/section_piece_param_helper'
require 'spree_theme/permitted_attributes_for_theme'
# support mobile
require 'slim'
require 'angularjs-rails'
# require assets
require 'rails-assets-bootstrap-sass-official'
require 'rails-assets-underscore'
require 'rails-assets-underscore.string'
require 'rails-assets-angular-bootstrap'
require 'rails-assets-angular-strap'
require 'rails-assets-angular-motion'
require 'rails-assets-bootstrap-additions'
require 'rails-assets-ngInfiniteScroll'
require 'rails-assets-angularytics'

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
