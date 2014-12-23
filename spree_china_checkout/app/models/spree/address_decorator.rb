Spree::Address.class_eval do
  #attr_accessible :city_name, :city_id # follow state
   
  before_validation :set_city, :only=>[:city]
    def self.default
      country = Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
      # add default state into default address
      state = country.states.first      
      new({:country => country,:state=>state})
    end
    
    
    
    private
      # Address.city should be present
      def set_city()
        selected_city = Spree::City.first(:conditions=>["id=?",city_id])
        self.city = selected_city.present? ? selected_city.name : city_name 
      end
    
      #copy from Address#state_validate
      def city_validate
        # Skip city validation without country (also required)
        # or when disabled by preference
        return if state.blank? || !Spree::Config[:address_requires_city]

        # ensure associated city belongs to state
        if city.present?
          if city.state == state
            self.city_name = nil #not required as we have a valid city and state combo
          else
            if city_name.present?
              self.city = nil
            else
              errors.add(:city, :invalid)
            end
          end
        end

        # ensure city_name belongs to state without cities, or that it matches a predefined city name/abbr
        if city_name.present?
          if state.cities.present?
            cities = state.cities.find_all_by_name_or_abbr(city_name)

            if cities.size == 1
              self.city = cities.first
              self.city_name = nil
            else
              errors.add(:city, :invalid)
            end
          end
        end

        # ensure at least one city field is populated
        errors.add :city, :blank if city.blank? && city_name.blank?
      end
end    


