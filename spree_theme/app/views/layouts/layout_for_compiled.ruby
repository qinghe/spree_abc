Rails.logger.debug "layout_for_compiled. self=#{self}"
self.send "compliled_template_theme_method_#{@theme.id}"
