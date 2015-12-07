module Spree
  module Api
    class TemplateThemesController < Spree::Api::BaseController

      def show
        respond_with(template_theme)
      end

      # Because JSTree wants parameters in a *slightly* different format
      def jstree
        show
      end

      def template_theme
        @template_theme ||= Spree::TemplateTheme.accessible_by(current_ability, :read).find(params[:id])
      end
    end
  end
end
