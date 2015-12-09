module Spree
  module Api
    class CitiesController < Spree::Api::BaseController
      #initializers/rabl_extra.rb is not working right.
      #get sight from api/controller_setup

      skip_before_filter :check_for_user_or_api_key
      skip_before_filter :authenticate_user

      def index
        @cities = scope.ransack(params[:q]).result.
                    includes(:state).order('name ASC')

        if params[:page] || params[:per_page]
          @cities = @cities.page(params[:page]).per(params[:per_page])
        end

        respond_with(@cities)
      end

      private
        def scope
          if params[:state_id]
            @state = Spree::State.accessible_by(current_ability, :read).find(params[:state_id])
            return @state.cities.accessible_by(current_ability, :read)
          else
            return Spree::State.accessible_by(current_ability, :read)
          end
        end
    end
  end
end
