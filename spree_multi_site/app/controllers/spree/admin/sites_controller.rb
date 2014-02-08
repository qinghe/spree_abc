module Spree
  module Admin
    class SitesController< Spree::Admin::ResourceController
      #resource_controller
      self.create.after( :create_after )
      def new
        @user = @site.users.build
        super                    
      end
      
      def create
        @user = Spree.user_class.new(params[:user])
        @site.users << @user
        super
      end
      
      def create_after
        @site.users.first.roles << Role.find_by_name("admin") 
        # should not add  @site.name as suffix of role.name, User.admin require :name="admin"
        if @site.has_sample?
          @site.load_sample
          #@site.update_attributes!(:loading_sample=>true)
          # add job to load sample
          #Delayed::Job.enqueue SampleSeedJob.new( @site )
        end
      end
     
      private
      #def collection
      #  @collection ||= current_site.self_and_children
      #end
    end
  end
end