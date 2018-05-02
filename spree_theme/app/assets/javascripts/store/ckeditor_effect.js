// handle effect for ckeditor content

$(document).on('turbolinks:load',function() {
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
      // background-color:transparent;color:#e20012;background-image:url('http://aliimg.getstore.cn/358/ckeditor_picture/598_arraw.jpg');
      if( hover_style)
      {
        var attrs = _.chain(hover_style.split(";")).map( function( attr ){
          line = attr.split(':');
          var cssDirective = line[0].trim();
          var cssValue = line.slice(1).join(':').trim();

          if (cssDirective.length < 1 || cssValue.length < 1) {
            return [] //there is no css directive or value that is of length  0
          }else{
            return [cssDirective, cssValue]
          }
        }).filter( function(attr){ return attr.length==2;}).value();
        //['color','red'] => { color: 'red' }
        attrs = _.object(attrs);
        $this.css( attrs);
        // it is difficult to parse background-image:url('http://aliimg.getstore.cn/358/ckeditor_picture/598_arraw.jpg'), so just set style
        // do not use this way, this would discard original style which not in data-style
        //$this.attr( 'style', hover_style )
      }
    },function(event){
      var $this =  $(this);
      var style = $this.data("style")
      if( style ) {
        var attrs = _.chain(style.split(";")).map( function( attr){ return attr.split(':')
          line = attr.split(':');
          var cssDirective = line[0].trim();
          var cssValue = line.slice(1).join(':').trim();

          if (cssDirective.length < 1 || cssValue.length < 1) {
            return [] //there is no css directive or value that is of length  0
          }else{
            return [cssDirective, cssValue]
          }
        }).filter( function(attr){ return attr.length==2;}).value();

        attrs = _.object(attrs);
        $this.css( attrs);
        //$this.attr( 'style', style )

      }else{
        $this.css({'background-color': '', 'color':''});
      }
    })
    // style in json, handle background-image:url('http://aliimg.getstore.cn/358/ckeditor_picture/598_arraw.jpg');

})
