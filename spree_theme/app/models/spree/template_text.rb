module Spree 
  class TemplateText < ActiveRecord::Base
    validates_presence_of :name
    attr_accessible :name, :body
    #for resource_class.resourceful
    scope :resourceful, ->(theme){ where("1=1") }
    
  end
end