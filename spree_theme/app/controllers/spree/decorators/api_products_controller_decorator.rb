Spree::Api::ProductsController.class_eval do
  
  #copy from sprangular
  def index
    @products = Spree::Product.active.includes(:option_types, :taxons, master: [:images, :option_values, :prices], product_properties: [:property], variants: [:images, :option_values, :prices])
    
    # get products assigned to default home page
    home_page = Spree::Site.current.try(:template_theme).try(:mobile).try(:home_page)
    @products = @products.in_taxon(home_page) unless home_page.blank?
    
    @products = @products.ransack(params[:q]).result if params[:q]
    @products = @products.distinct.page(params[:page]).per(params[:per_page])

    respond_with(@products)
  end



end
