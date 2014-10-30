    Spree::Admin::ProductsController.class_eval do
      update.before :prepare_more_params
      create.before :prepare_more_params
      around_filter :only=>[:create,:edit, :update, :destroy] do |controller, action_block|
        Spree::MultiSiteSystem.setup_context('admin_site_product')
        action_block.call
        Spree::MultiSiteSystem.setup_context #reset multi_site_system
      end
   
      
      private
      def prepare_more_params
        if params[:product][:global_taxon_ids].present?
          params[:product][:global_taxon_ids] = params[:product][:global_taxon_ids].split(',')
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].split(',')
        end        
      end  
      
      #def prepare_multi_site_context
      #  Spree::MultiSiteSystem.setup_context('admin_site_product')
      #end    
    end