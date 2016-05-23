class Spree::RelationType < ActiveRecord::Base
  default_scope ->{ where(:site_id=>SpreeTheme.site_class.current.id)}

  #for resource_class.resourceful
  scope :resourceful, ->(theme){ where("1=1") }

  has_many :relations, dependent: :destroy

  validates :name, :applies_to, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :site_id }
end
