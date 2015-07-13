module Spree
  module Admin
    class TemplateFilesController < Spree::Admin::ResourceController
      
      
      def collection
        model_class.where( ["theme_id in (?)", Spree::Site.current.template_theme_ids] ).includes(:template_theme)        
      end
    end    
  end
end 
