#it is not using now.
module Spree
  class CompiledTemplateTheme
    attr_accessor :template_theme
    delegate :current_template_release, to: :template_theme

    class << self
        def compiled_method_name_prefix_regex
          /\A_cttm_at[\d]+_/
        end
    end

    def initialize( template_theme )
      self.template_theme = template_theme
    end

    def render
      send self.compiled_method_name
    end

    def method_missing(method_name, *args, &block)
      if template_theme_id = template_theme_id_from_method_name( method_name )
        #Rails.logger.debug "self=#{self}, method_name=#{method_name} template_theme_id=#{template_theme_id}"
        define_compiled_template_theme_method( template_theme_id )
        self.send(method_name, *args)
      else
        super
      end
    end

    # compliled template theme method format
    # _cttm_at{current_template_release.updated_at.to_i}_#{current_template_release.theme_id}
    # method for generate page, consider template theme may refer to another template_theme in design shop
    def compiled_method_name
      method_name = "#{compiled_method_name_prefix}#{current_template_release.theme_id}"
    end


    def compiled_method_name_prefix
      "_cttm_at#{current_template_release.updated_at.to_i}_"
    end

    private
    def define_compiled_template_theme_method( template_theme_id )

      method_name = compiled_method_name
Rails.logger.info "SpreeTheme definde_method: #{method_name} #{self.object_id}"
      self.send("instance_eval", "def #{method_name}; #{File.read(template_theme.layout_path)}; end", '(CompiledTemplateTheme)')
    end

    # Returns style of image or nil
    def template_theme_id_from_method_name(method_name)
      regex = self.class.compiled_method_name_prefix_regex
      if method_name.to_s.match(regex) && template_theme_id = method_name.to_s.sub(regex, '')
        template_theme_id if self.current_template_release.present?
      end
    end
  end
end
