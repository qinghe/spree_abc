class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_attached_file :data,
                    :url => "/shops/:rails_env/:site/ckeditor_assets/attachments/:id/:filename",
                    :path => ":rails_root/public/shops/:rails_env/:site/ckeditor_assets/attachments/:id/:filename"
  
  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  do_not_validate_attachment_file_type :data

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
