module Spree
  class CitiesController < BaseController
    ssl_allowed :index

    respond_to :js

    def index
      # we return ALL known information, since billing country isn't restricted
      # by shipping country
      logger.debug "cities=#{cities_path}"
      respond_with @city_info = Spree::City.cities_group_by_state_id.to_json, :layout => nil
    end
  end
end