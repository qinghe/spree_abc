module Spree
  class SectionPiece < ActiveRecord::Base
    extend FriendlyId
    has_many  :sections
    has_many  :section_piece_params
    friendly_id :title, :use => :slugged
    
    # resources m:either/m:signup
    # return array of struct{:resource, :context}    
    def wrapped_resources
        collection = resources.split('/').collect{|res_ctx|
          resource, context = res_ctx.split(':')
          Struct.new(:resource, :context)[resource, context.to_sym]          
        }      
    end
    
  end
end