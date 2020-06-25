Spree::FrontendHelper.module_eval do
  def flash_messages(opts = {})
    ignore_types = ["order_completed"].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

    flash.each do |msg_type, text|
      unless ignore_types.include?(msg_type)
        concat(content_tag :div, text, class: "alert alert-#{msg_type} alert-auto-disappear")
      end
    end
    nil
  end
end
