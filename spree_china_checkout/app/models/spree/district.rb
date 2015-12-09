module Spree
  class District < ActiveRecord::Base
    belongs_to :city

    validates :city, :name, :presence => true

    #attr_accessible :name, :abbr

    def self.find_all_by_name_or_abbr(name_or_abbr)
      where('name = ? OR abbr = ?', name_or_abbr, name_or_abbr)
    end

  end
end
