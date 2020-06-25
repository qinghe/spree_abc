#Rails.logger.debug "layout_for_compiled. self=#{self}"
self.send "#{@theme.complied_method_name}"
