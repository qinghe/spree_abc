module Spree
  
  # file uploaded for template
  class TemplateFile < ActiveRecord::Base
    belongs_to :template_theme, :foreign_key=>"theme_id"
  
    #validates_uniqueness_of :file_name
    has_attached_file :attachment
    self.attachment_definitions[:attachment][:url] = "/shops/:rails_env/:site/:class/:id/:basename_:style.:extension"
    self.attachment_definitions[:attachment][:path] = ":rails_root/public/shops/:rails_env/:site/:class/:id/:basename_:style.:extension"
    self.attachment_definitions[:attachment][:default_url] = "/images/:style/missing.png"
  
    delegate :url, :to => :attachment
    #it is required while import theme with new template_file. we would set theme.assigned_resources while import.
    attr_accessor :page_layout_id
    attr_accessible :theme_id, :attachment, :page_layout_id
    #for resource_class.resourceful
    scope :resourceful, ->(theme){ where(:theme_id=>theme.id)}
    #get resource name.
    alias_attribute(:name, :attachment_file_name)
    
    #it is required, even for logo, app_configuration has default logo, each theme could customize logo 
    validate :template_theme, :presence=>true
    
    #deep dup
    def dup
      original_dup = super
      original_dup.attachment = self.attachment
      original_dup
    end
  end
end