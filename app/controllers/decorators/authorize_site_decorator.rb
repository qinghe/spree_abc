Spree::TemplateThemesController.class_eval do
  #store could preview native template theme
  #before_filter :authorize_site

  #def authorize_site
  #  # Site.current.god? would not work, god site loaded for unexist domain
  #  unless Store.current.designable?
  #    redirect_to 'http://'+Store.god.subdomain, status: :moved_permanently
  #    #raise CanCan::AccessDenied.new("Not authorized!", :access, Site)
  #  end
  #end
end
Spree::SitesController.class_eval do
  #only www.tld could access this controller
  before_filter :authorize_site

  def authorize_site
    # Site.current.god? would not work, god site loaded for unexist domain
    unless request.host.end_with? Spree::Site.system_top_domain
      redirect_to 'http://'+Spree::Store.god.subdomain, status: :moved_permanently
      #raise CanCan::AccessDenied.new("Not authorized!", :access, Site)
    end
  end
end
