# a post could have several attachments
class Spree::StoreFavicon < Spree::StoreAsset

  #attr_accessible :alt, :attachment

  has_attached_file :attachment,
                    :url => "/shops/:rails_env/:class/:id/:filename",
                    :path => ":rails_root/public/shops/:rails_env/:class/:id/:filename",
                    styles: { mini: '48x48>' },
                    default_url: '/assets/images/favicon.ico'

  validates_attachment :attachment, presence: true,
    content_type: { content_type: %w(image/x-icon image/vnd.microsoft.icon) },
    size: { in: 0..1.megabytes }
end
