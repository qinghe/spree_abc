class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Paperclip
  default_scope  { where(:site_id =>  Spree::Site.current.id) }
end
