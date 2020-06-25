
handle_select = (e, data) ->
  selected_node = data.rslt.obj
  url = [Spree.routes.admin_page_layouts( selected_node.data('tid')),selected_node.data('lid'), selected_node.data('action') ].join('/')
  $.ajax({ url: url, type: 'GET', dataType: "script"})

root = exports ? this
root.setup_template_theme_tree = (template_theme_id) ->
  $template_theme_tree = $("#template_theme_tree")
  if template_theme_id != undefined
    conf =
      core:
        multiple: false,
        animation: 0
      themes:
        theme: "spree2",
        url: Spree.url(Spree.routes.jstree_theme_path)
      #strings:
      #  loading: Spree.translations.loading + "..."
      #plugins: ["themes"]

    $template_theme_tree.jstree( conf  )
      .bind("select_node.jstree", handle_select)
