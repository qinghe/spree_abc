module Spree
  module Admin
    class TemplateThemesController < Spree::Admin::BaseController
      before_filter :load_theme, :only => [:apply, :import, :edit, :update, :release, :copy_theme]

      def index
        native
      end
      #list themes
      def native
        @themes = TemplateTheme.native
        render :action=>:native
      end

      def foreign
        @themes = TemplateTheme.foreign.includes(:template_releases)
        @themes = @themes.select{|theme| theme.template_releases.present?}
      end

      def import
        imported_theme = @theme.import
        respond_to do |format|
          format.html { redirect_to(foreign_admin_template_themes_url) }
        end    
      end
      
      #apply this theme to site
      def apply
        #create template_release before call lg.release
        if @theme.template_releases.present?
          SpreeTheme.site_class.current.apply_theme @theme.template_releases.last
        elsif @theme.foreign_template_release.present?
          SpreeTheme.site_class.current.apply_theme @theme          
        end  
          
        @themes = TemplateTheme.native          
        render :action=>'native' 
      end

      begin 'designer'
        #copy selected theme to new theme
        def copy
          @original_theme = TemplateTheme.find(params[:id])
          #copy theme, layout, param_value
          @new_theme = @original_theme.copy_to_new
          
          respond_to do |format|
            format.html { redirect_to(admin_template_themes_url) }
          end    
        end

        def release
          #create template_release before call lg.release    
          if @theme.has_native_layout?     
            template_release = @theme.template_releases.build
            template_release.name = "just a test"
            template_release.save
            SpreeTheme.site_class.current.apply_theme template_release
             
            @lg = PageGenerator.releaser( template_release)
            @lg.release
          end
          @themes = TemplateTheme.native          
          render :action=>'native' 
        end
        
        # DELETE /themes/1
        # DELETE /themes/1.xml
        def destroy
          @theme = TemplateTheme.find(params[:id])
          @theme.destroy
      
          respond_to do |format|
            format.html { redirect_to(admin_template_themes_url) }
            format.xml  { head :ok }
          end
        end
    
      end

      private
      def load_theme
        @theme = TemplateTheme.find(params[:id])
        authorize! action, @theme
      end
    end
  end
end
