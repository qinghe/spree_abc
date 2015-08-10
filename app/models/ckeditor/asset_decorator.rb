# improve for aliyun oss
Ckeditor::AttachmentFile.class_eval do
  extend SpreeMultiSite::PaperclipAliyunOssHelper
end

Ckeditor::Picture.class_eval do
  extend SpreeMultiSite::PaperclipAliyunOssHelper
end
