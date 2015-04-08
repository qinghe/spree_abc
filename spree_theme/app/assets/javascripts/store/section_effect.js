//= require image-zoom
//= require jquery.menuhover

$(document).ready(function() {
  //return to top
  $('.return_top').click(function(){
    //var $element =$(this); 
    //$("#return_top").hide();
    //$(window).scroll(function(){
    //  if ($(window).scrollTop()>100){
    //      $("#return_top").fadeIn(500);
    //      }
    //  else{
    //  $("#return_top").fadeOut(1500);
    //      }
    //});
    $("body,html").animate({scrollTop:0},1000);
    return false;    
  });
  
  // change bg,border when hovering
  $('.hoverable').hover(function(){
      $('.inner',this).addClass( 'hover' );
  }, function(){
      $('.inner',this).removeClass( 'hover' );      
  });
  
  // like taobao, show big image when hovering product image.
  $('.zoomable').each(function(index, element){
    var $element =$(element); 
    var $main_image_wrapper = $element.find('.main_image_wrapper');
    $element.find('.thumbnails a').click(function(){
      var $this = $(this);
      $main_image_wrapper.find('img').data('big-image', $this.find('img').data('big-image'));
    });
    $element.imageZoom({
            zoomType: 'standard',
            lens:true,
            preloadImages: false,
            alwaysOn:false,
            thumbConfig: {
              containerSelector: null//'.thumbnails'
            },
            zoomViewerConfig:{
              width: $main_image_wrapper.width()-2, // 2 is border l+r
              height: $main_image_wrapper.height()-2
            },
            zoomPadConfig: {
              containerSelector: '.main_image_wrapper'
            }
        });
  });
  
  // scroll to target
  $('.effect_scroll').click(function() {
    var $body = (window.opera) ? (document.compatMode == "CSS1Compat" ? $('html') : $('body')) : $('html,body');
    var $self = $(this);
    var $target = $($self.attr('href'));
    if($target.is('*')) {
      $body.animate({
        scrollTop : ($target.offset().top - 120)
      }, 500);
      return false;
    }
  });
  
  function ScaleSlider(jssor_slider) {
      var parentWidth = $(jssor_slider.$Elmt.parentNode).width();
      if(parentWidth)
        jssor_slider.$SetScaleWidth(parentWidth);
      else
        window.setTimeout(ScaleSlider, 30);
  }

  
  $(".effect_slider").each(function(index, element) {
    var $self = $(element);
    var $parent = $self.parent();
    var $slide_container = $self.children("[u='slides']");
    $self.css({
        height : $parent.css('height'),
        width : $parent.css('width')
      });
    $slide_container.css({
        height : $parent.css('height'),
        width : $parent.css('width')
      });
    var options = null;
    if( $self.hasClass("scrolling")){
        var slide_width = $self.find("[u='slides']>div").width();
        var display_piece = Math.ceil( $parent.width() / slide_width );
        // get width of a slide
        options = {
                $AutoPlay: true,                                    //[Optional] Whether to auto play, to enable slideshow, this option must be set to true, default value is false
                $AutoPlaySteps: 1,                                  //[Optional] Steps to go for each navigation request (this options applys only when slideshow disabled), the default value is 1
                $AutoPlayInterval: 0,                               //[Optional] Interval (in milliseconds) to go for next slide since the previous stopped if the slider is auto playing, default value is 3000
                $PauseOnHover: 4,                                   //[Optional] Whether to pause when mouse over if a slider is auto playing, 0 no pause, 1 pause for desktop, 2 pause for touch device, 3 pause for desktop and touch device, 4 freeze for desktop, 8 freeze for touch device, 12 freeze for desktop and touch device, default value is 1

                $ArrowKeyNavigation: true,                          //[Optional] Allows keyboard (arrow key) navigation or not, default value is false
                $SlideEasing: $JssorEasing$.$EaseLinear,            //[Optional] Specifies easing for right to left animation, default value is $JssorEasing$.$EaseOutQuad
                $SlideDuration: 1600,                               //[Optional] Specifies default duration (swipe) for slide in milliseconds, default value is 500
                $MinDragOffsetToSlide: 20,                          //[Optional] Minimum drag offset to trigger slide , default value is 20
                $SlideWidth: slide_width,     //it is requried         //[Optional] Width of every slide in pixels, default value is width of 'slides' container
                //$SlideHeight: 100,                                //[Optional] Height of every slide in pixels, default value is height of 'slides' container
                $SlideSpacing: 0,                                   //[Optional] Space between each slide in pixels, default value is 0
                $DisplayPieces: display_piece, //it is required         //[Optional] Number of pieces to display (the slideshow would be disabled if the value is set to greater than 1), the default value is 1
                $ParkingPosition: 0,                                //[Optional] The offset position to park slide (this options applys only when slideshow disabled), default value is 0.
                $UISearchMode: 1,                                   //[Optional] The way (0 parellel, 1 recursive, default value is 1) to search UI components (slides container, loading screen, navigator container, arrow navigator container, thumbnail navigator container etc).
                $PlayOrientation: 1,                                //[Optional] Orientation to play slide (for auto play, navigation), 1 horizental, 2 vertical, 5 horizental reverse, 6 vertical reverse, default value is 1
                $DragOrientation: 1                                 //[Optional] Orientation to drag slide, 0 no drag, 1 horizental, 2 vertical, 3 either, default value is 1 (Note that the $DragOrientation should be the same as $PlayOrientation when $DisplayPieces is greater than 1, or parking position is not 0)
            };
        
    } else{
        options = {
                $FillMode : 2,
                $AutoPlay : true,
                $BulletNavigatorOptions : {
                  $Class : $JssorBulletNavigator$,
                  $ChanceToShow : 2,
                  $AutoCenter : 1
                }
              };
    } 
    if( $slide_container.children().length>0){        
        var jssor_slider1 = new $JssorSlider$($self.get(0), options);
        //responsive code begin
        //you can remove responsive code if you don't want the slider scales while window resizes
        //Scale slider immediately
        ScaleSlider(jssor_slider1);
        //if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
        //    $(window).bind('resize', ScaleSlider);
        //}
        //responsive code end
    }
  });

  if($("#map").is('*')) {
    // initialize baid map.
    initMap();
  };

  // dom
  // div.hover_effect_xxx
  //   .child_1
  //   .child_2
  // div.hover_effect_xxx
  //   .child_1
  //   .child_2

  //menu effect slide
  $(".hover_effect_slide").each(function(index, element) {
    //nav sliding
    var height = '' + $('.child_1', element).height() + 'px';
    var offset = '-' + height;
    //$('.name',element).css({ height: height});
    $('.child_2', element).css({
      bottom : offset,
      height : height
    });
    //nav sliding
    $(element).hover(function() {
      $(".child_1", this).stop().animate({
        top : offset,
        left : '0px'
      }, {
        queue : false,
        duration : 300
      });
      $(".child_2", this).stop().animate({
        bottom : '0px',
        left : '0px'
      }, {
        queue : false,
        duration : 300
      });
    }, function() {
      $(".child_1", this).stop().animate({
        top : '0px',
        left : '0px'
      }, {
        queue : false,
        duration : 300
      });
      $(".child_2", this).stop().animate({
        bottom : offset,
        left : '0px'
      }, {
        queue : false,
        duration : 300
      });
    });
  });
  //
  $('.hover_effect_show').hover(function() {
    $('.child_2', this).stop().slideDown();
  }, function() {
    $('.child_2', this).stop().slideUp();
  });
  //slides the element with class "menu_body" when mouse is over the paragraph
  $(".hover_effect_expansion .child_1").mouseover(function() {
    $(this).parents('.hover_effect_expansion').addClass('hovered').siblings().removeClass('hovered');
    $(this).next(".child_2").slideDown(500);
    $(this).parents('.hover_effect_expansion').siblings().find('.child_2').slideUp("slow");
  });

  $(".hover_effect_overlay").hover(function() {
    var offset = '-' + $('.child_1', this).width() + 'px';
    $(".child_2", this).stop().animate({
      top : '0',
      left : offset
    }, {
      queue : false,
      duration : 400
    });
  }, function() {
    $(".child_2", this).stop().animate({
      top : '0px',
      left : '0px'
    }, {
      queue : false,
      duration : 400
    });
  });
  
  //  usage: compute child_2 display position of window for effect popup 
  //    html <div id='container'> 
  //           <div class='child_1'></div> <div class='child_2'></div>
  //         </div>
  //  params: direction- there are five option values  t,r,b,l,rl,
  //
  function compute_popup_position( $container, direction ){
      var $self = $container;
      var child1 = $(".child_1", $self);
      var child2 = $(".child_2", $self);
      var offset = child1.offset();
      // get silbings, get parent.width, get current
      // get currentTarge.pageX,
      var position = [0,0];
      // top, left
      var block = $(window);
      var scroll_top = block.scrollTop();
      var scroll_left = block.scrollLeft();
      if ( direction == 'rl' ){
          var p = $self.parent().width() / 2 - $self.position().left - $self.width();
          if(p >= 0) {// pop up on right side of child2
            position[0] = offset.top - (child2.height() - child1.height() ) / 2 - scroll_top;
            position[1] = offset.left + child1.width();
          } else {// pop up on left side of $self
            position[0] = offset.top - (child2.height() - child1.height() ) / 2 - scroll_top;
            position[1] = offset.left - child2.width();
          }            
      }else if ( direction == 'b' ){
          position[0] = offset.top  +   child1.height() - scroll_top;;
          position[1] = offset.left - (child2.width() - child1.width() ) / 2 - scroll_left;
      }else if ( direction == 't' ){
          position[0] = offset.top  -   child2.height() - scroll_top;;
          position[1] = offset.left - (child2.width() - child1.width() ) / 2 - scroll_left;
      }else if ( direction == 'l' ){
          position[0] = offset.top - (child2.height() - child1.height() ) / 2 - scroll_top;
          position[1] = offset.left - child2.width();
      }else if ( direction == 'bl' ){
          position[0] = offset.top - (child2.height() - child1.height() )  - scroll_top;
          position[1] = offset.left - child2.width();
      }
      return position;
  }
  
  $(".hover_effect_popup").hover(function(e) {      
      var position = compute_popup_position( this, 'rl' );
      //console.log( "pos y=%d, x=%d", position[0], position[1] );
      $(".child_2", this).simplemodal({
        appendTo: '#page-wrapper',
        modal : false,
        focus : false,
        position : position,
        fixed : false
      });
    }, function() {
      $.simplemodal.close();
    });

  // popup menu, enable mouse hover on popup div, user could click menu on it.
  $(".hover_effect_popup_menu_l,.hover_effect_popup_menu").each(function(i, element){
      var $self = $(element);
      var direction = 'b';
      if ($self.hasClass('hover_effect_popup_menu_l')){
          direction = 'l';
      }
      function activate_element(  ){
          var $hover_effect_container = this.$hover_effect_container;
          var position = compute_popup_position( $hover_effect_container, direction );
          //console.log( "pos y=%d, x=%d", position[0], position[1] );
          $(".child_2", $hover_effect_container).simplemodal({
            appendTo: '#page-wrapper',
            modal : false,
            focus : false,
            position : position,
            fixed : false
          });
      }
      function deactivate_element(  ){
          $.simplemodal.close();
      }      
      var child1 = $(".child_1", this);
      var child2 = $(".child_2", this);
      
      $(element).menuhover({
          activate: activate_element,
          deactivate: deactivate_element,
          submenuDirection: direction,
          $hover: child2
      });
      
  });

  
});
