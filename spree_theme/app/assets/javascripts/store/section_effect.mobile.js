
$(function() {
  //"content_layout s_551_2 c_549 effect_infinitescroll u_container"
  var section_css_class_regex = /\bs\_([0-9]+)\_([0-9]+)\b/;

  $("#page").on( 'tap', '.sidr_overlay', function(e) {
    //sidr0-overlay
    var sidr_name = $(this).attr('id').split('-').shift();
    $.sidr( 'close', sidr_name );
    e.preventDefault();
  });
  // prevent scrolling happen
  $('#page').on('drag', '.sidr_overlay', function(e) {
    // prevent default horizontal scrolling
    e.preventDefault();
  });


  $('.infinitescroll').each(function(i, element){
    var $element = $(element);
    var css_class = $element.attr('class');
    var matches = css_class.match( section_css_class_regex );
    var section_css_class = matches[0]
    var section_id = matches[1];
//console.debug( section_css_class, '.'+section_css_class+" .pagination .next a")
    if( $('.pagination', this).is('*') ){
      var ias = jQuery.ias({
        container:  '.'+section_css_class+"> .inner",
        item:       ' .c_'+section_id,
        pagination: '.'+section_css_class+" .pagination",
        next:       '.'+section_css_class+" .pagination .next a"
      });
      //disable spinner since it maybe always showing if too much scroll event.
      // shows a spinner (a.k.a. loader)
      //ias.extension(new IASSpinnerExtension());
      // shows a trigger after page 3
      ias.extension(new IASTriggerExtension({offset: 3}));
      ias.extension(new IASNoneLeftExtension());
      //$element.infinitescroll({
      //  loading: {
      //    msgText: "<em>努力加载中...</em>",
      //    finishedMsg: "<em>恭喜你,已无更多内容.</em>"
      //  },
      //  //debug           : true,
      //  contentSelector : '.'+section_css_class+"> .inner",
      //  navSelector     : '.'+section_css_class+" .pagination",
      //  // selector for the paged navigation (it will be hidden)
      //  nextSelector    : '.'+section_css_class+" .pagination .next a",
      //  // selector for the NEXT link (to page 2)
      //  itemSelector    : '.'+section_css_class+' .c_'+section_id,
      //  // selector for all items you'll retrieve
      //});
    }
  });
});
