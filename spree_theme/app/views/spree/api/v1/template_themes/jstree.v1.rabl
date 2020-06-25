object false
node(:data) { @template_theme.page_layout_root.title }
node(:attr) do
  { :id => @template_theme.page_layout_root.id,
    :name => @template_theme.page_layout_root.title
  }
end
node(:state) { "closed" }
