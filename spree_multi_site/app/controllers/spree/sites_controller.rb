#encoding: utf-8
module Spree
    class SitesController< StoreController
      respond_to :html,:js
      
      def new
        if params[:template_theme_id].present?
          @template_theme = Spree::TemplateTheme.foreign.find params[:template_theme_id]  
        end
        @site =  Site.new
        @user = @site.users.build
      end
      
      # called from dalianshops home page
      def quick_lunch
        params[:user][:password_confirmation] = params[:user][:password] 
        @site = create_site( params[:site], params[:user] )
        if @site.persisted?
          redirect_to @site.admin_url
        else
          redirect_to root_path()            
        end        
      end
      
      def show
        @site =  Site.find(params[:id])
        render :after_new
      end
      
      def create
        @site = create_site( params[:site], params[:user] )
        if @site.persisted?
          flash[:success] = Spree.t(:site_successfully_opened, :site_name => @site.name)
          #redirect_to @site.admin_url, format: 'js', status: 303
          respond_with(@site) do |format|
            format.html { redirect_to @site.admin_url }
            format.js { render :js => "window.location = '#{@site.admin_url}'" }
          end         
        else
          respond_with(@site) do |format|
            format.js { render :action => 'new'}
          end         
        end
      end
            
      # options 
      def create_site( site_params, user_params, options= {})
        site = Site.new(site_params)
        user = Spree.user_class.new(user_params)
        site.users << user
        if site.save
          site.users.first.spree_roles << Spree::Role.find_by_name('admin')
          shipping_category = site.shipping_categories.create!( :name=>Spree.t(:default))
          # should not add  @site.name as suffix of role.name, User.admin require :name="admin"
          if site.has_sample?
            site.load_sample
            #@site.update_attributes!(:loading_sample=>true)
            # add job to load sample
            #Delayed::Job.enqueue SampleSeedJob.new( @site )
          end 
        else
          flash[:error] = Spree.t('errors.messages.could_not_create_site')
        end  
        site
      end
           
    end
  
end