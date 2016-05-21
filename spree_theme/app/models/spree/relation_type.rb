class Spree::RelationType < ActiveRecord::Base
  default_scope ->{ where(:site_id=>SpreeTheme.site_class.current.id)}

  has_many :relations, dependent: :destroy

  validates :name, :applies_to, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
