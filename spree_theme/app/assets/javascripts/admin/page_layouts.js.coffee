handle_ajax_error = (XMLHttpRequest, textStatus, errorThrown) ->
  $.jstree.rollback(last_rollback)
  $("#ajax_error").show().html("<strong>" + server_error + "</strong><br />" + page_layout_tree_error)

handle_move = (e, data) ->
  last_rollback = data.rlbk
  position = data.rslt.cp
  node = data.rslt.o
  new_parent = data.rslt.np

  url = Spree.url(base_url).clone()
  url.setPath url.path() + '/' + node.prop("id")
  $.ajax
    type: "POST",
    dataType: "json",
    url: url.toString(),
    data: {
      _method: "put",
      "page_layout[parent_id]": new_parent.prop("id"),
      "page_layout[child_index]": position,
      token: Spree.api_key
    },
    error: handle_ajax_error

  true

handle_rename = (e, data) ->
  last_rollback = data.rlbk
  node = data.rslt.obj
  name = data.rslt.new_name

  url = Spree.url(base_url).clone()
  url.setPath(url.path() + '/' + node.prop("id"))

  $.ajax
    type: "POST",
    dataType: "json",
    url: url.toString(),
    data: {
      _method: "put",
      "page_layout[name]": name,
      token: Spree.api_key
    },
    error: handle_ajax_error

handle_delete = (e, data) ->
  last_rollback = data.rlbk
  node = data.rslt.obj
  delete_url = base_url.clone()
  delete_url.setPath delete_url.path() + '/' + node.prop("id")
  jConfirm Spree.translations.are_you_sure_delete, Spree.translations.confirm_delete, (r) ->
    if r
      $.ajax
        type: "POST",
        dataType: "json",
        url: delete_url.toString(),
        data: {
          _method: "delete",
          token: Spree.api_key
        },
        error: handle_ajax_error
    else
      $.jstree.rollback(last_rollback)
      last_rollback = null

root = exports ? this
root.setup_template_theme_tree = (template_theme_id) ->
  if template_theme_id != undefined
    # this is defined within admin/taxonomies/edit
    # /api/template_themes/:template_theme_id/page_layouts
    root.base_url = Spree.url(Spree.routes.template_theme_page_layouts_path)

    $.ajax
      url: Spree.url(base_url.path().replace("/page_layouts", "/jstree")).toString(),
      data:
        token: Spree.api_key
      success: (template_theme) ->
        last_rollback = null

        conf =
          json_data:
            data: template_theme,
            ajax:
              url: (e) ->
                # /api/template_themes/:template_theme_id/page_layouts/
                Spree.url(base_url.path() + '/' + e.prop('id') + '/jstree' + '?token=' + Spree.api_key).toString()
          themes:
            theme: "spree",
            url: Spree.url(Spree.routes.jstree_theme_path)
          strings:
            loading: Spree.translations.loading + "..."
          crrm:
            move:
              check_move: (m) ->
                position = m.cp
                node = m.o
                new_parent = m.np

                # no parent or cant drag and drop
                if !new_parent || node.prop("rel") == "root"
                  return false

                # can't drop before root
                if new_parent.prop("id") == "page_layout_tree" && position == 0
                  return false

                true
          plugins: ["themes", "json_data", "dnd", "crrm", "contextmenu"]

        $("#page_layout_tree").jstree(conf)
          .bind("move_node.jstree", handle_move)
          .bind("remove.jstree", handle_delete)
          .bind("rename.jstree", handle_rename)
          .bind "loaded.jstree", ->
            $(this).jstree("core").toggle_node($('.jstree-icon').first())

    $("#page_layout_tree a").on "dblclick", (e) ->
      $("#page_layout_tree").jstree("rename", this)

    # surpress form submit on enter/return
    $(document).keypress (e) ->
      if e.keyCode == 13
        e.preventDefault()
