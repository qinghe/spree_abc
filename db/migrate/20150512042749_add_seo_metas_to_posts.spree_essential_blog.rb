# This migration comes from spree_essential_blog (originally 20150511195253)
class AddSeoMetasToPosts < ActiveRecord::Migration
  def change
    change_table :spree_posts do |t|
      t.string   :meta_title
      t.string   :meta_description
      t.string   :meta_keywords
    end
  end
end
