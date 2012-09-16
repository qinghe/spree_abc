Spree::HomeController.class_eval do

    def index_with_render_new_site
      if current_site == Spree::Site.admin_site
        redirect_to new_site_path      
      else
        index_without_render_new_site
      end
    end
    
    alias_method_chain :index, :render_new_site
    
    
  
end
