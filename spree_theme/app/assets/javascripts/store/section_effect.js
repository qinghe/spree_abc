//= require image-zoom

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

  
  $('.zoomable').each(function(index, element){
    var $element =$(element); 
    var $main_image_wrapper = $element.find('.main_image_wrapper')
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
  })
  
  $('.effect_scroll').click(function() {
    var $body = (window.opera) ? (document.compatMode == "CSS1Compat" ? $('html') : $('body')) : $('html,body');
    var $self = $(this)
    var $target = $($self.attr('href'));
    if($target.is('*')) {
      $body.animate({
        scrollTop : ($target.offset().top - 120)
      }, 500);
      return false;
    }
  });

  $(".effect_slider").each(function(index, element) {
    var self = $(element);
    var parent = self.parent();
    var options = {
      $FillMode : 2,
      $AutoPlay : true,
      $BulletNavigatorOptions : {
        $Class : $JssorBulletNavigator$,
        $ChanceToShow : 2,
        $AutoCenter : 1
      }
    };
    self.css({
      height : parent.css('height'),
      width : parent.css('width')
    });
    self.children("[u='slides']").css({
      height : parent.css('height'),
      width : parent.css('width')
    });
    var jssor_slider1 = new $JssorSlider$(self.get(0), options);
    //responsive code begin
    //you can remove responsive code if you don't want the slider scales while window resizes
    function ScaleSlider() {
      var parentWidth = jssor_slider1.$Elmt.parentNode.clientWidth;
      if(parentWidth)
        jssor_slider1.$SetScaleWidth(parentWidth);
      else
        window.setTimeout(ScaleSlider, 30);
    }

    //Scale slider immediately
    ScaleSlider();
    //if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
    //    $(window).bind('resize', ScaleSlider);
    //}
    //responsive code end

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

  $(".hover_effect_popup").hover(function(e) {
    var self = $(this);
    var child1 = $(".child_1", this);
    var child2 = $(".child_2", this);
    var p = self.parent().width() / 2 - self.position().left - self.width();
    var offset = child1.offset();
    // get silbings, get parent.width, get current
    // get currentTarge.pageX,
    var position = [];
    // top, left
    var block = $(window);
    var scroll_top = block.scrollTop();
    var scroll_left = block.scrollLeft();
    if(p >= 0) {// pop up on right side of child2
      position[0] = offset.top - (child2.height() - child1.height() ) / 2 - scroll_top;
      position[1] = offset.left + child1.width();
    } else {// pop up on left side of self
      position[0] = offset.top - (child2.height() - child1.height() ) / 2 - scroll_top;
      position[1] = offset.left - child2.width();
    }
    //console.log( "pos y=%d, x=%d", position[0], position[1] );
    $(".child_2", this).simplemodal({
      modal : false,
      focus : false,
      position : position,
      fixed : false
    });
  }, function() {
    $.simplemodal.close();
  });
});
