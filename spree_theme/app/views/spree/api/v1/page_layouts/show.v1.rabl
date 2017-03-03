object @page_layout
attributes *page_layout_attributes

child :children => :page_layouts do
  attributes *page_layout_attributes
end
