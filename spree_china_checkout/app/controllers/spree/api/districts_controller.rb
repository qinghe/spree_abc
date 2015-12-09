module Spree
  module Api
    class DistrictsController < Spree::Api::BaseController
      #initializers/rabl_extra.rb is not working right.
      #get sight from api/controller_setup

      skip_before_filter :check_for_user_or_api_key
      skip_before_filter :authenticate_user

      def index
        @districts = scope.ransack(params[:q]).result.
                    includes(:city).order('name ASC')

        if params[:page] || params[:per_page]
          @districts = @districts.page(params[:page]).per(params[:per_page])
        end

        respond_with(@districts)
      end

      private
        def scope
          if params[:city_id]
            @city = Spree::City.accessible_by(current_ability, :read).find(params[:city_id])
            return @city.districts.accessible_by(current_ability, :read)
          else
            return Spree::District.accessible_by(current_ability, :read)
          end
        end
    end
  end
end
