module Spree
  class City < ActiveRecord::Base
  # attr_accessible :title, :body
    belongs_to :state

    validates :state, :name, :presence => true

    attr_accessible :name, :abbr

    def self.find_all_by_name_or_abbr(name_or_abbr)
      where('name = ? OR abbr = ?', name_or_abbr, name_or_abbr)
    end

    # table of { country.id => [ state.id , state.name ] }, arrays sorted by name
    # blank is added elsewhere, if needed
    def self.cities_group_by_state_id
      city_info = Hash.new { |h, k| h[k] = [] }
      self.order('name ASC').each { |city|
        city_info[city.state_id.to_s].push [city.id, city.name]
      }
      city_info
    end
  end
end

