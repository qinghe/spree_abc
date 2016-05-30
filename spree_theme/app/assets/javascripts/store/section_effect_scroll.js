// it is using jssor.20 for effect slider
function ScaleSlider(jssor_slider) {
  // console.debug( jssor_slider )
  //Object { $Elmt=div.effect_slider,  $Options={...},  $PlayTo=PlayTo(),  more...}
  //Object { data=slider, originalEvent=Event load,  type="load",  timeStamp=0,  more...}
  var element = ( jssor_slider.$Elmt || jssor_slider.data.$Elmt )
  if( element ){
    var parentWidth= $(element.parentNode).width();
    if(parentWidth=false)
      jssor_slider.$ScaleWidth(parentWidth);//jssor_slider.$SetScaleWidth(parentWidth);
    //else
    //  window.setTimeout(function(jssor_slider){ ScaleSlider(jssor_slider); }, 30);
  }
}
$(document).ready(function() {

  // dom structure
  //   <div class="container">  <div class="inner">
  //      <!-- div.effect_slider is required, jssor manipulate it. -->
  //      <div class='effect_slider'> <div u='slides' data-options..>
  //         <div> slide1 </div>
  //         <div> slide2 </div>
  //      </div> </div>
  //   </div> </div>
  $(".effect_slider").each(function(index, element) {
    var $self = $(element);
    var $parent = $self.parent();
    var $slide_container = $self.children("[u='slides']");
    var $arrow_navigator = $self.children(".arrowleft");
    var $bullet_navigator = $self.children("[u='navigator']");
    // if parent height is 1, use width. it is for product image slider on mobile
    var height = $parent.height();
    if (height > 1){
      $self.css({ height : $parent.css('height'), width : $parent.css('width')  });
      $slide_container.css({ height : $parent.css('height'), width : $parent.css('width') });
    }else{
      $self.css({ height : $parent.css('width'), width : $parent.css('width')  });
      $slide_container.css({ height : $parent.css('width'), width : $parent.css('width') });
    }
    var transitions = { fade: [{$Duration:1200,$Opacity:2}] };
    var options = null, slideshow_options=null;
    var auto_play = ( $slide_container.data('auto-play') == null ?  true : $slide_container.data('auto-play') );
    var display_pieces = $slide_container.data('display-pieces');
    var transition_name =  $slide_container.data('transition');


    if( display_pieces ){
        var slide_width = $self.find("[u='slides']>div").width();
        var display_piece = Math.ceil( $parent.width() / slide_width );
        // get width of a slide
        options = {
                $AutoPlay: auto_play,                                    //[Optional] Whether to auto play, to enable slideshow, this option must be set to true, default value is false
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
                $Cols: display_piece, // new for 2.0
                $ParkingPosition: 0,                                //[Optional] The offset position to park slide (this options applys only when slideshow disabled), default value is 0.
                $UISearchMode: 1,                                   //[Optional] The way (0 parellel, 1 recursive, default value is 1) to search UI components (slides container, loading screen, navigator container, arrow navigator container, thumbnail navigator container etc).
                $PlayOrientation: 1,                                //[Optional] Orientation to play slide (for auto play, navigation), 1 horizental, 2 vertical, 5 horizental reverse, 6 vertical reverse, default value is 1
                $DragOrientation: 1                                 //[Optional] Orientation to drag slide, 0 no drag, 1 horizental, 2 vertical, 3 either, default value is 1 (Note that the $DragOrientation should be the same as $PlayOrientation when $DisplayPieces is greater than 1, or parking position is not 0)
            };

    } else{
      // arrow or bullet navigator
      options = {
                $AutoPlay : auto_play,
                $FillMode : 2
      };
      if( $bullet_navigator.is('*')){
        options['$BulletNavigatorOptions'] = {
          $Class : $JssorBulletNavigator$,
          $ChanceToShow : 2,
          $AutoCenter : 1
        }
      }
      if( $arrow_navigator.is('*')){
        options['$ArrowNavigatorOptions'] = {
          $Class : 	$JssorArrowNavigator$,
          $ChanceToShow : 1,
          $AutoCenter : 2
        }
      }
      if( transitions[transition_name] ){
        options['$SlideshowOptions'] = {
          $Class: $JssorSlideshowRunner$,
          $Transitions: transitions[transition_name]
        }
      }

    }
    if( $slide_container.children().length>0){
        var jssor_slider1 = new $JssorSlider$($self.get(0), options);
        //responsive code begin
        //you can remove responsive code if you don't want the slider scales while window resizes
        //Scale slider immediately
        ScaleSlider(jssor_slider1);

        //Scale slider while window load/resize/orientationchange.
        $(window).bind("load", jssor_slider1, ScaleSlider);
        $(window).bind("resize",jssor_slider1, ScaleSlider);
        $(window).bind("orientationchange", jssor_slider1, ScaleSlider);
        //responsive code end
    }
  });
});
