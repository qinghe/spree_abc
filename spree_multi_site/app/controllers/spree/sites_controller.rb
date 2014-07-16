#encoding: utf-8
module Spree
    class SitesController< StoreController
      def new
        if request.get?
          @site =  Site.new
          @user = @site.users.build
        else
          @site = create_site( params[:site], params[:user] ) 
          if @site
            redirect_to site_path(@site)
          end
        end
      end
      
      def quick_lunch
        params[:user][:password_confirmation] = params[:user][:password] 
        @site = create_site( params[:site], params[:user] )
        if @site
          redirect_to @site.admin_url
        else
          redirect_to root_path()            
        end        
      end
      
      def show
        @site =  Site.find(params[:id])
        render :after_new
      end
      
      # options 
      def create_site( site_params, user_params, options= {})
        site =  Site.new(site_params)
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
        site.persisted? ? site : nil       
      end
           
    end
  
end