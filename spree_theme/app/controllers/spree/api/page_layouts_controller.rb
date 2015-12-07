module Spree
  module Api
    class PageLayoutsController < Spree::Api::BaseController
      #initializers/rabl_extra.rb is not working right.
      #get sight from api/controller_setup
      append_view_path File.expand_path("../../../views", File.dirname(__FILE__))

      def show
        @page_layout = page_layout
        respond_with(@page_layout)
      end

      def jstree
        show
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

    end
  end
end
