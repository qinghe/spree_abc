class Spree::Blogs::Admin::PostFilesController < Spree::Admin::ResourceController

  before_filter :load_data

  create.before :set_viewable
  update.before :set_viewable
  destroy.before :destroy_before

  def update_positions
    params[:positions].each do |id, index|
      Spree::PostFile.update_all(['position=?', index], ['id=?', id])
    end

    respond_to do |format|
      format.js  { render :text => 'Ok' }
    end
  end

  private

  def location_after_save
    admin_post_files_url(@post)
  end

  def load_data
    @post = Spree::Post.find_by_permalink!(params[:post_id])
  end

  def set_viewable
    @post_file.viewable = @post
  end

  def destroy_before
    @viewable = @post_file.viewable
  end

end
