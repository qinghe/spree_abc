Spree::BaseHelper.module_eval do 
    def logo_text()
      link_to Spree::Site.current.name, root_path,:id=>"logo-text"
    end

end
