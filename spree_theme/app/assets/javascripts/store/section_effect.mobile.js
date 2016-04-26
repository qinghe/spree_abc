
$(function() {
  $("#page").on( 'tap', '.sidr_overlay', function(e) {
    $.sidr( 'close','sidr');
    e.preventDefault();
  });
  // prevent scrolling happen
  $('#page').on('drag', '.sidr_overlay', function(e) {
    // prevent default horizontal scrolling
    e.preventDefault();
  });

});
