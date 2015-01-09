    Spree::Admin::GeneralSettingsController.class_eval do
      #override original, update site model
      #def update
      #  params.each do |name, value|
      #    next unless Spree::Config.has_preference? name
      #    Spree::Config[name] = value
      #    if name =='site_name'
      #      Spree::Site.current.update_attribute(:name, value)
      #    end  
      #    if name =='site_url'
      #      Spree::Site.current.update_attribute(:domain, value)
      #    end  
      #  end
      #  flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:general_settings))
      #
      #  redirect_to edit_admin_general_settings_path
      #end
    end