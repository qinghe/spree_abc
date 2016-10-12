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

    // <div class = "ck_effect_hover">
    // <a data-hover-bg-color="green"> link </a>
    // </div>
    $(".ck_effect_hover a").hover(function(event){
      var $this =  $(this);
      var hover_style = $this.data("hover-style")
      // background-color:white;color:black
      if( hover_style)
      {
        var attrs = _.chain(hover_style.split(";")).map( function( attr){ return attr.split(':')}).filter( function(attr){ return attr.length==2;}).value();
        //['color','red'] => { color: 'red' }
        attrs = _.object(attrs);
        $this.css( attrs);
      }
    },function(event){
      var $this =  $(this);
      var normal_style = $this.data("style")
      if( normal_style )
      {
        var attrs = _.chain(normal_style.split(";")).map( function( attr){ return attr.split(':')}).filter( function(attr){ return attr.length==2;}).value();
        attrs = _.object(attrs);
        $this.css( attrs);
      }else{
        $this.css({'background-color': '', 'color':''});
      }
    })

})
