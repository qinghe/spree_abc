    Spree::Admin::ProductsController.class_eval do
      #before_filter :load_data
      #private
      #def load_data
      #  @sites = current_site.self_and_descendants
      #  @tax_categories = TaxCategory.find(:all, :order=>"name")  
      #  @shipping_categories = ShippingCategory.find(:all, :order=>"name")  
      #end
      
      
 #     def collection
 #      base_scope = super.by_site_with_descendants(current_site)

        # Note: the SL scopes are on/off switches, so we need to select "not_deleted" explicitly if the switch is off
        # QUERY - better as named scope or as SL scope?
 #       if params[:search].nil? || params[:search][:deleted_at_not_null].blank?
 #         base_scope = base_scope.not_deleted
 #       end

 #       @search = base_scope.search(params[:search])
 #       @search.order ||= "ascend_by_name"

 #       @collection = @search.paginate(:include  => {:variants => :images},
 #                                      :per_page => Spree::Config[:admin_products_per_page], 
 #                                      :page     => params[:page])
 #       base_scope = super.by_site(current_site)
 #       @collection = base_scope.all
 #     end      
      
    end