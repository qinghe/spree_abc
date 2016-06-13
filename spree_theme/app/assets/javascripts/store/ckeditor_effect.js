// handle effect for ckeditor content

$(document).ready(function() {
  //<div class=ck_effect_page>
  //  <div class="ck_effect_page_nav"> <a> 1</a> <a>2</a> </div>
  //  <div class="ck_effect_page_content">
  //    <div > content 1 </div>
  //    <div > content 2 </div>
  //  </div>
  //</div>

    $(".ck_effect_page_nav a.page").click(function(event){
      var $this =  $(this);
      var $page_content = $this.parent().siblings('.ck_effect_page_content');
      var i = $this.prevAll('.page').size();
      $page_content.children().removeClass('current').hide().eq(i).addClass('current').show();
      event.preventDefault();
    })
    $(".ck_effect_page_nav a.next").click(function(event){
      var $this =  $(this);
      var $page_content = $this.parent().siblings('.ck_effect_page_content').children('.current');
      if( $page_content.next().is('*')){
        $page_content.removeClass('current').hide().next().addClass('current').show();
      }
      event.preventDefault();
    })
    $(".ck_effect_page_nav a.prev").click(function(event){
      var $this =  $(this);
      var $page_content = $this.parent().siblings('.ck_effect_page_content').children('.current');
      if( $page_content.prev().is('*')){
        $page_content.removeClass('current').hide().prev().addClass('current').show();
      }
      event.preventDefault();
    })

    //http://stackoverflow.com/questions/5811122/how-to-trigger-a-click-on-a-link-using-jquery
    if( $('.ck_effect_screen_logo').is('*')){
      window.setTimeout("$('.ck_effect_screen_logo').children().click()", 3000)
    }

})
