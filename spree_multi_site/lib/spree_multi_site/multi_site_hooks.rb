=begin
  
Deface::Override.new(:virtual_path => "layouts/admin",
                     :name => "converted_admin_tabs_104517776",
                     :insert_after => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%=  tab(:sites)  %>",
                     :disabled => false)

Deface::Override.new(:virtual_path => "admin/product_scopes/_form",
                     :name => "converted_admin_product_form_left_283172874",
                     :insert_after => "[data-hook='admin_product_form_left'], #admin_product_form_left[data-hook]",
                     :text => "
    <% f.field_container :site do %>
      <%= f.label :site, t(\"site\") %> <span class=\"required\">*</span><br />
      <%= f.collection_select :site_id, @sites, :id, :name, {:include_blank => false} %>
      <%= f.error_message_on :site %>
    <% end %>    
    ", :disabled => false)

Deface::Override.new(:virtual_path => "admin/taxonomies/_form",
                     :name => "converted_admin_inside_taxonomy_form_526819528",
                     :insert_after => "[data-hook='admin_inside_taxonomy_form'], #admin_inside_taxonomy_form[data-hook]",
                     :text => "
    <p>
      <%= label_tag \"taxonomy_site_id\", t(\"site\") %><br />
      <%= error_message_on :taxonomy, :site %>
      <%= collection_select(:taxonomy, :site_id, @sites, :id, :name, {:include_blank => false}, {\"style\" => \"width:200px\"}) %> 
    </p>
    ",:disabled => false)

Deface::Override.new(:virtual_path => "admin/orders/index",
                     :name => "converted_admin_orders_index_headers_256012504",
                     :insert_before => "[data-hook='admin_orders_index_headers'], #admin_orders_index_headers[data-hook]",
                     :text => "<th><%= order @search, :by => :site_name, :as => t(\"site\") %></th>",
                     :disabled => false)

Deface::Override.new(:virtual_path => "admin/orders/index",
                     :name => "converted_admin_orders_index_rows_280863796",
                     :insert_before => "[data-hook='admin_orders_index_rows'], #admin_orders_index_rows[data-hook]",
                     :text => "<td><%= ((order.site.name) if order.site) %></td>",
                     :disabled => false)

class MultiSiteHooks < Spree::ThemeSupport::HookListener 
  insert_after :admin_tabs do
    %(<%=  tab(:sites)  %>)
  end

  insert_after :admin_product_form_left do
    %(
    <% f.field_container :site do %>
      <%= f.label :site, t("site") %> <span class="required">*</span><br />
      <%= f.collection_select :site_id, @sites, :id, :name, {:include_blank => false} %>
      <%= f.error_message_on :site %>
    <% end %>    
    )
  end

  insert_after :admin_inside_taxonomy_form do
    %(
    <p>
      <%= label_tag "taxonomy_site_id", t("site") %><br />
      <%= error_message_on :taxonomy, :site %>
      <%= collection_select(:taxonomy, :site_id, @sites, :id, :name, {:include_blank => false}, {"style" => "width:200px"}) %> 
    </p>
    )
  end
  
  insert_before :admin_orders_index_headers do
    %(<th><%= order @search, :by => :site_name, :as => t("site") %></th>)
  end
  
  insert_before :admin_orders_index_rows do
    %(<td><%= ((order.site.name) if order.site) %></td>)
  end

end
=end