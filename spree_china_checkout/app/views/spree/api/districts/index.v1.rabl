object false
if @city
  node(:districts_required) { true }
end

child(@districts => :districts) do
  attributes *[:id, :name, :abbr, :city_id]
end

if @districts.respond_to?(:num_pages)
  node(:count) { @districts.count }
  node(:current_page) { params[:page] || 1 }
  node(:pages) { @districts.num_pages }
end
