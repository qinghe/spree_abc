module Spree
  class SectionPiece < ActiveRecord::Base
    cattr_accessor :resource_classes
    self.resource_classes = [SpreeTheme.taxon_class, Spree::TemplateText, Spree::TemplateFile, Spree::SpecificTaxon]
    extend FriendlyId
    has_many  :sections
    has_many  :section_piece_params
    friendly_id :title, :use => :slugged
    scope :with_resources, where(["resources!=?",''])    
    # resources m:/m:signup
    # return array of struct{:resource, :context}    
    def wrapped_resources
        collection = resources.split('/').collect{|res_ctx|
          resource, context = res_ctx.split(':')          
          Struct.new(:resource, :context,:resource_class).new.tap{|wrapped_resource|
            wrapped_resource.resource = resource
            wrapped_resource.context  = (context ? context.to_sym : DefaultTaxon::ContextEnum.home)
            wrapped_resource.resource_class = case wrapped_resource.resource
              when 'm'
                SpreeTheme.taxon_class
              when 't'
                Spree::TemplateText
              when 'i'
                Spree::TemplateFile
            end 
          }
        }      
    end
    
  end
end