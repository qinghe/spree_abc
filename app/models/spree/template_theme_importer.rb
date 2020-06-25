module Spree
  class TemplateThemeImporter
    attr_accessor :original_template_theme
    def initialize( template_theme)
      self.original_template_theme = template_theme
    end


    #import template theme design into current site
    #only create template record, do not copy param_value,page_layout,template_file...
    # * params
    #   * resource_config - new configuration for resource
    def import(new_attributes={})
      new_theme = duplicate_template_theme( new_attributes )

    end

    # for simple to user, copy taxonomy as well when import.
    #
    def import_with_resource( new_attributes={})
      Spree::TemplateTheme.transaction do
        new_theme = import( new_attributes )
        duplicate_assigned_resource( new_theme )
        new_theme
      end
    end


    def duplicate_template_theme( new_attributes )
      #import template theme design into current site
      #only create template record, do not copy param_value,page_layout,template_file...
      #mobile template is unpublic, it should be duplicatable
        raise ArgumentError unless original_template_theme.template_releases.exists?
        #only released template and :is_public is importable
        #create theme record
        new_theme = original_template_theme.dup
        #set resource to site native
        new_theme.title = "Imported "+ new_theme.title
        new_theme.attributes = new_attributes
        new_theme.assigned_resource_ids = {}
        new_theme.site_id =  Spree::Store.current.site_id
        new_theme.store_id = Spree::Store.current.id
        new_theme.copy_from_id = original_template_theme.id
        new_theme.save!
        new_theme

    end


    # copy taxon,text,image, specific-taxon from original_theme to new_theme
    def duplicate_assigned_resource( new_theme )
      original_template_resources = original_template_theme.template_resources
      # new_theme.assigned_resource_ids is empty now
      new_theme.assigned_resource_ids = original_template_theme.assigned_resource_ids.dup
      # import each resource
      # template_file(logo), template_text, taxon(menu),
      new_theme.template_resources.each{| template_resource |
        unscoped_source = template_resource.unscoped_source
        if unscoped_source.present? && unscoped_source.importable?
           new_source = template_resource.source_class.find_or_copy unscoped_source
           template_resource.update_attribute!(:source_id, new_source.id)
        else
         template_resource.destroy!
        end
      }
      # assgin imported resource to new_theme
    end

  end
end
