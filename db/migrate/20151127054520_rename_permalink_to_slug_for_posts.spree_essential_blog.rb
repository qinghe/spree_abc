# This migration comes from spree_essential_blog (originally 20151125000001)
class RenamePermalinkToSlugForPosts < ActiveRecord::Migration
  def change
    rename_column :spree_posts, :permalink, :slug
  end
end
