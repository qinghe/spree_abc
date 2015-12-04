SpreeTheme.taxon_class.class_eval do
    include Spree::Context::Taxon

    before_destroy :remove_from_theme
    before_validation :set_default_values
    #for resource_class.resourceful
    scope :resourceful,->(theme){ roots }

    belongs_to :replacer, class_name: 'Spree::Taxon', foreign_key: 'replaced_by'
    serialize :html_attributes, Hash
    #attr_accessible :page_context, :replaced_by, :is_clickable

    alias_attribute :extra_html_attributes, :html_attributes

    def summary( truncate_at=100)
      #copy from Action View Sanitize Helpers
      Rails::Html::FullSanitizer.new.sanitize( description || '' ).truncate( truncate_at )
    end

    def remove_from_theme
      Spree::TemplateTheme.native.each{|theme|
        theme.unassign_resource_from_theme! self
      }
    end


    #strange,  Mysql2::Error: Column 'page_context' cannot be null: UPDATE `spree_taxons` SET `html_attributes` = '--- {}\n', `page_context` = NULL, `replaced_by` = 491, `updated_at` = '2015-04-08 12:51:34' WHERE `spree_taxons`.`id` = 460
    #"taxon"=>{"name"=>"新闻中心", "replaced_by"=>"491", "page_context"=>"", "is_clickable"=>"1", "description"=>"", "meta_title"=>"", "meta_description"=>"", "meta_keywords"=>""},
    # so set page_context 0 here if it is empty?
    def set_default_values
      self.page_context = 0 if page_context.blank?
      self.replaced_by = 0 if replaced_by.blank?
    end

    def stylish_with_inherited
      return self.stylish if self.stylish>0
      return root.stylish
    end
end
