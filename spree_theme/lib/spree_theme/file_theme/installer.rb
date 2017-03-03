module SpreeTheme
  module FileTheme
    module Installer
      extend ActiveSupport::Concern

      included do
        helper_method :theme_name
      end

      def handle_file_theme( theme )
        prepend_view_path file_theme_instance(theme).theme_view_path
        @special_layout = "layout"
      end


      def file_theme_instance( theme=nil )
        if theme.present?
          @file_theme_instance = SpreeTheme::FileTheme::ActionController.new(self, theme )
        end
        @file_theme_instance 
      end

      def theme_name
        file_theme_instance.theme_name
      end

    end
  end
end
