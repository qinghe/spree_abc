# a post could have several attachments
class Spree::PostImage < Spree::Asset

  #attr_accessible :alt, :attachment

  has_attached_file :attachment,
    :styles => Proc.new{ |clip| clip.instance.attachment_sizes },
    :default_style => :medium,
    :url => '/shops/:rails_env/:site/:class/:id/:basename_:style.:extension',
    :path => ':rails_root/public/shops/:rails_env/:site/:class/:id/:basename_:style.:extension'
  validates_attachment :attachment,
      :presence => true,
      :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif) }
 
  def attachment_sizes
    hash = {}
    hash.merge!(:mini => '48x48>', :small => '150x150>', :medium => '600x600>', :large => '950x700>') if image_content?
    hash
  end
    
end
