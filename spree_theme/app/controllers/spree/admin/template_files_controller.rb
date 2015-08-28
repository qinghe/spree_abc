module Spree
  module Admin
    class TemplateFilesController < Spree::Admin::ResourceController


      def collection
        return @collection if @collection.present?
        # params[:q] can be blank upon pagination
        params[:q] = {} if params[:q].blank?

        @collection = model_class.where( ["theme_id in (?)", SpreeTheme.site_class.current.template_theme_ids] ).includes(:template_theme)
        @search = @collection.ransack(params[:q])

        @search.result.page(params[:page]).per(Spree::Config[:orders_per_page]).order('theme_id')
      end
    end
  end
end
