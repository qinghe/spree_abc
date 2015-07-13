class Sprangular::ProductsController < Sprangular::BaseController

  def index
    product_ids =  template_scoped_product_ids
    @products = Spree::Product.active.includes(:option_types, :taxons, master: [:images, :option_values, :prices], product_properties: [:property], variants: [:images, :option_values, :prices])
    @products = @products.where( id: product_ids) if product_ids  
    @products = @products.ransack(params[:q]).result if params[:q]      
    @products = @products.distinct.page(params[:page]).per(params[:per_page])

    render 'spree/api/products/index'
  end

  def show
    @product = Spree::Product.active.where(slug: params[:id]).first!

    render 'spree/api/products/show'
  end
  
  # for design site, show products belongs to current template_theme
  def template_scoped_product_ids
    Spree::Site.current.try(:template_theme).try(:mobile).try(:home_page).try(:product_ids) if Spree::Site.current.design?
  end
end
