collection @page_layout.children, :object_root => false
node(:data) { |page_layout| page_layout.title }
node(:attr) do |page_layout|
  { :id => page_layout.id,
    :name => page_layout.title
  }
end
node(:state) { "closed" }
