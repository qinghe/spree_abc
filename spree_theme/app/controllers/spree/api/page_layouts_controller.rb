module Spree
  module Api
    class PageLayoutsController < Spree::Api::BaseController
      #initializers/rabl_extra.rb is not working right.
      #get sight from api/controller_setup

      def show
        @page_layout = page_layout
        respond_with(@page_layout)
      end

      def jstree
        show
      end

      def update
        authorize! :update, page_layout
        if page_layout.update_attributes(page_layout_params)
          respond_with(page_layout, status: 200, default_template: :show)
        else
          invalid_resource!(page_layout)
        end
      end

      private

      def template_theme
        if params[:template_theme_id].present?
          @template_theme ||= Spree::TemplateTheme.accessible_by(current_ability, :read).find(params[:template_theme_id])
        end
      end

      def page_layout
        @page_layout ||= template_theme.page_layouts.accessible_by(current_ability, :read).find(params[:id])
      end

      def page_layout_params
        if params[:page_layout] && !params[:page_layout].empty?

          params.require(:page_layout).permit(permitted_page_layout_attributes)
        else
          {}
        end
      end
    end
  end
end
