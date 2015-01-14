Spree::Api::ProductsController.class_eval do
  
  #copy from sprangular
  def index
    if params[:ids]
      @products = product_scope.where(:id => params[:ids].split(","))
    else
      @products = product_scope.ransack(params[:q]).result
    end    
    # get products assigned to default home page
    home_page = Spree::Site.current.try(:template_theme).try(:mobile).try(:home_page)
    @products = @products.joins(:taxons).where(Spree::Taxon.table_name => { :id => home_page.id }) if home_page
    
    @products = @products.distinct.page(params[:page]).per(params[:per_page])
    expires_in 15.minutes, :public => true
    headers['Surrogate-Control'] = "max-age=#{15.minutes}"
    respond_with(@products)
  end



end
