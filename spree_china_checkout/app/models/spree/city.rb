module Spree
  class City < ActiveRecord::Base
    belongs_to :state
    has_many :districts
    validates :state, :name, :presence => true

  end
end
