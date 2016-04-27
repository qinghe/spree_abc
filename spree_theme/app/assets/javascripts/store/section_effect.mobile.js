
$(function() {
  //"content_layout s_551_2 c_549 effect_infinitescroll u_container"
  var section_css_class_regex = /\bs\_([0-9]+)\_([0-9]+)\b/;

  $("#page").on( 'tap', '.sidr_overlay', function(e) {
    $.sidr( 'close','sidr');
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
    var section_css_class = matches[0]//
    var section_id = matches[1];
//console.debug( section_css_class, '.'+section_css_class+" .pagination .next a")
    $element.infinitescroll({
      //debug           : true,
      contentSelector : '.'+section_css_class+"> .inner",
      navSelector     : '.'+section_css_class+" .pagination",
      // selector for the paged navigation (it will be hidden)
      nextSelector    : '.'+section_css_class+" .pagination .next a",
      // selector for the NEXT link (to page 2)
      itemSelector    : '.'+section_css_class+' .c_'+section_id,
      // selector for all items you'll retrieve
    });
  });
});
