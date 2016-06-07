// handle effect for ckeditor content

$(document).ready(function() {
  //<div class=ck_effect_page>
  //  <div class="ck_effect_page_nav"> <a> 1</a> <a>2</a> </div>
  //  <div class="ck_effect_page_content">
  //    <div > content 1 </div>
  //    <div > content 2 </div>
  //  </div>
  //</div>

    $(".ck_effect_page_nav a").click(function(event){
      var $this =  $(this);
      var $page_content = $this.parent().siblings('.ck_effect_page_content');
      var i = $this.prevAll().size();
      $page_content.children().hide().eq(i).show();
      event.preventDefault();
    })

})
