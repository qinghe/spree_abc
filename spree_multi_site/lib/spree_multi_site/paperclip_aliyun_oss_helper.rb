# include into model
module PaperclipAliyunOssHelper
  # original path and url
  # :url  => "/shops/:rails_env/:site/ckeditor_assets/pictures/:id/:style_:basename.:extension",
  # :path => ":rails_root/public/shops/:rails_env/:site/ckeditor_assets/pictures/:id/:style_:basename.:extension",

  def self.extended( base )
    if base.storage_aliyun?
      base.fix_path_for_aliyun_oss
    end
  end

  def fix_path_for_aliyun_oss
    puts " it is called"
    # ex. Spree::Taxon   path = 1/taxon/1_test.jpg
    path = ":site/:simple_class/:id_:filename"
    attachment_definitions[:attachment][:path] = path
    attachment_definitions[:attachment][:url] = '/'+path
    attachment_definitions[:attachment][:styles] = {} #no need styles anymore. it is supproted by oss style
  end

  def storage_aliyun?
   (attachment_definitions[:storage]||Paperclip::Attachment.default_options[:storage]) == :aliyun
  end
end
