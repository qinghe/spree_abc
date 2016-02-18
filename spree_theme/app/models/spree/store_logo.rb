# a post could have several attachments
class Spree::StoreLogo < Spree::StoreAsset

  #attr_accessible :alt, :attachment

  has_attached_file :attachment,
                    :url => "/shops/:rails_env/:class/:id/:style_:filename",
                    :path => ":rails_root/public/shops/:rails_env/:class/:id/:style_:filename",
                    styles: { mini: '48x48>' },
                    default_url: '/assets/images/logo/dalianshops.png'

  validates_attachment :attachment, presence: true,
    content_type: { content_type: %w(image/jpg image/jpeg image/png image/gif) },
    size: { in: 0..5.megabytes }
end
