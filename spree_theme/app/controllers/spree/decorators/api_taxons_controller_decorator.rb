Spree::Api::TaxonsController.class_eval do
  # read global taxon of dalianshops from other site
  def global

      if params[:ids]
        @taxons = Spree::Taxon.accessible_by(current_ability, :read).unscoped.where(:site_id=>Spree::Store.god.id ).where(:id => params[:ids].split(","))
      else
        @taxons = Spree::Taxon.accessible_by(current_ability, :read).unscoped.where(:site_id=>Spree::Store.god.id ).order(:taxonomy_id, :lft).ransack(params[:q]).result
      end
    @taxons = @taxons.page(params[:page]).per(params[:per_page])
    respond_with(@taxons, :default_template => :index)

  end
end
