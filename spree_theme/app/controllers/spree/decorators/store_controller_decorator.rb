#encoding: utf-8
module Spree
    StoreController.class_eval do
      #override spree_front/store_controller#unauthorized
      def unauthorized  
        if @theme.blank?
          # unlogged user access /account would trigger unauthorized without initialize_template,
          initialize_template( root_path )
        end
        render 'spree/shared/unauthorized', :status => 401
      end
      
      def config_locale       
        # under_construction,unauthorized @theme is nil
        return @theme.locale if @theme && @theme.locale.present?
        Spree::Frontend::Config[:locale]
      end
        
    end
end