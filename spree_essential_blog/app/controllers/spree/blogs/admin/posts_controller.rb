class Spree::Blogs::Admin::PostsController < Spree::Admin::ResourceController

  update.before :set_category_ids
  
  def index
    session[:return_to] = request.url
    respond_with(@collection)
  end
  
  def new
    @post = Spree::Post.new
    @post.posted_at ||= Time.now
  end

private
  
  def set_category_ids
    if params[:post] && params[:post][:taxon_ids].present?
      params[:post][:taxon_ids] = params[:post][:taxon_ids].split(',')
    end    
  end
  
  def location_after_save
    #in this way keep current page of posts after save.     
    session[:return_to] || admin_posts_url
  end 
  
  def find_resource
  	@object ||= Spree::Post.find_by_permalink!(params[:id])
  end
  
  def collection
    params[:search] ||= {}
    params[:search][:meta_sort] ||= "posted_at.desc"
    @search = Spree::Post.search(params[:q])
    @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
  end

end
