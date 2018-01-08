//= require image_zoom
//= require jquery.menuhover
//= require jquery.ias.dev
//= require jquery.sidr
//= require store/section_effect_scroll
//= require store/ckeditor_effect

function AddFavorite() {
    var url = window.location;
    var title = document.title;
    var ua = navigator.userAgent.toLowerCase();
    if (ua.indexOf("360se") > -1) {
      alert(Spree.translations.unsupported_browser_add_favorite);
    }
    else if (ua.indexOf("msie 8") > -1) {
        window.external.AddToFavoritesBar(url, title); //IE8
    }
    else if (document.all) {
      try{
        window.external.addFavorite(url, title);
      }catch(e){
        alert(Spree.translations.unsupported_browser_add_favorite);
      }
    }
    //else if(window.sidebar) {
    //  // add rel=sidebar
    //  // firefox handle it.
    //}
    else {// firefox,chrome,safair
      alert(Spree.translations.unsupported_browser_add_favorite);
    }
}

function SetHome(){
  try{
    this.style.behavior='url(#default#homepage)';
    this.setHomePage(window.location);
  }catch(e){
    alert(Spree.translations.unsupported_browser_set_home);
  }
}



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
  $('.zoomable').each(function(i, element){
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


  $('.lightboxable').each( function(i, element){

    var $element =$(element);
    var $main_image = $element.find('.main_image_wrapper img');
    var jsonData =[];
    var thumbnails = $element.find('.thumbnails img');
    if( thumbnails.is('*') ){
        thumbnails.each(function(j,img){
            jsonData.push({ url:$(img).data('big-image'), title: img.alt });
        });
    }else{
        jsonData.push({ url:$main_image.data('big-image'), title: $main_image.attr('alt') });
    }

    $main_image.lightbox({
        fitToScreen: true,
        jsonData: jsonData,
        loopImages: true,
        imageClickClose: false,
        disableNavbarLinks: true
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
  $(".hover_effect_multi_level_menu").each(function(index, element) {
    // navigation  horizental two level menu
    //  menu item1 | menu item2 hovering | menu item3
    //             | menu item21         |
    //             | menu item22         |
    $("ul ul", element).css({
        display: "none"
    }); // Opera Fix
    $("ul li", element).hover(function() {
        $(this).find('ul:first').css({
            visibility: "visible",
            display: "none"
        }).slideDown("normal");
    },  function() {
        $(this).find('ul:first').css({
            visibility: "hidden"
        });
    });

  });
  //  usage: compute child_2 display position of window for effect popup
  //    html <div id='container'>
  //           <div class='child_1'></div> <div class='child_2'></div>
  //         </div>
  //  params: direction- there are five option values  t,r,b,l,rl,
  //            it composite of three character.
  //            xya: x axis, y axis, a alignment.  ex. lbl,  position left bottom, align left
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
      }else if ( direction == 'lbl' ){
          position[0] = offset.top - (child2.height() - child1.height() )  - scroll_top;
          position[1] = offset.left - child2.width();
      }
      return position;
  }

  $(".hover_effect_popup").hover(function(e) {
      var $this = $(this);
      var direction = 'rl';
      if ($this.hasClass('direction-t')){
        direction = 't';
      }
      var position = compute_popup_position( $this, direction );
      //console.log( "pos y=%d, x=%d", position[0], position[1] );
      $(".child_2", this).simplemodal({
        appendTo: '#page-wrapper',
        closeHTML:'',  // remove a.close, or get incorrect container demension
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
      var direction = 'b';// popup at bottom, center as well.
      if ($self.hasClass('hover_effect_popup_menu_l')){
        direction = 'l';
      }else if ($self.hasClass('hover_effect_popup_menu_lbl')){
        direction = 'lbl';
      }
      function activate_element(  ){
          var $hover_effect_container = this.$hover_effect_container;
          var position = compute_popup_position( $hover_effect_container, direction );
          //console.log( "pos y=%d, x=%d", position[0], position[1] );
          $(".child_2", $hover_effect_container).simplemodal({
            appendTo: '#page-wrapper',
            closeHTML:'', // remove a.close, or get incorrect container demension
            modal : false,
            focus : false,
            position : position,
            fixed : false
          });
      };
      function deactivate_element(  ){
          $.simplemodal.close();
      };
      var child1 = $(".child_1", this);
      var child2 = $(".child_2", this);
      // eliminate empty popup simplemodal
      if(child2 && child2.children().html().trim().length>0){
        $(element).menuhover({
            activate: activate_element,
            deactivate: deactivate_element,
            submenuDirection: direction,
            $hover: child2
        });
      }
  });

  $(".click_effect_sider").each(function(i, element){
    var child2 = $(".child_2", element);
    //var class_names = $(".child_2", element).attr('class').replace(/(^\s+)|(\s+$)/g,"").replace(/\s+/g,'.');
      $(".child_1", element).sidr({
        name: 'sidr'+i,
        body: '#page-inner', // append into page innner, apply page css.
        displace: false,
        renaming: false,
        source: function(){
          return ( child2.is("*") ? child2[0].outerHTML : "no content");
          }
      });
  });
  $(".sidr").on( 'click touchstart',".sidr_close",function(){
    //<div id="sidr0"> <div class='sidr_close_container'> <a class="sidr_close"></a> </div>
    //</div>
    var sidr_name = $(this).parents('.sidr').attr('id')
    $.sidr( 'close', sidr_name);
  });
  $("#page").on( 'click touchstart',".sidr_overlay",function(){
    //<div id="sidr0"> </div>
    //<div id="sidr0-overlay"> </div>
    //sidr0-overlay
    var sidr_name = $(this).attr('id').split('-').shift();
    $.sidr( 'close',sidr_name);
  });

});
