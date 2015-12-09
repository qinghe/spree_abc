object false
if @state
  node(:states_required) { true }
end

child(@cities => :cities) do
  attributes *[:id, :name, :abbr, :state_id]
end

if @cities.respond_to?(:num_pages)
  node(:count) { @cities.count }
  node(:current_page) { params[:page] || 1 }
  node(:pages) { @cities.num_pages }
end
