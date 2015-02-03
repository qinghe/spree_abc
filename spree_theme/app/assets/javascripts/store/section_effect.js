$(document).ready(function() {

    if($("#map").is('*')){
      // initialize baid map.
      initMap();    
    }  
    
    // dom
    // div.hover_effect_xxx
    //   .child_1
    //   .child_2
    // div.hover_effect_xxx
    //   .child_1
    //   .child_2
    
    //menu effect slide
    $(".hover_effect_slide").each(function(index, element){
                  //nav sliding   
            var height = ''+ $('.child_1',element).height()+'px';
            var offset = '-'+ height ;
            //$('.name',element).css({ height: height});
            $('.child_2',element).css({ bottom:offset, height: height});
            //nav sliding            
            $(element).hover(function(){
                $(".child_1",this).stop().animate({top:offset,left:'0px'},{queue:false,duration:300});
                $(".child_2",this).stop().animate({bottom:'0px',left:'0px'},{queue:false,duration:300});
            },function(){
                $(".child_1",this).stop().animate({top:'0px',left:'0px'},{queue:false,duration:300});
                $(".child_2",this).stop().animate({bottom:offset,left:'0px'},{queue:false,duration:300});
                 
                }); 
    }); 
    
    //            
    $('.hover_effect_show').hover(function(){            
        $('.child_2',this).stop().slideDown();
    },function(){
        $('.child_2',this).stop().slideUp();         
    });
    
    //slides the element with class "menu_body" when mouse is over the paragraph
    $(".hover_effect_expansion .child_1").mouseover(function()
    {
      $(this).parents('.hover_effect_expansion').addClass('hovered').siblings().removeClass('hovered');
      $(this).next(".child_2").slideDown(500);
      $(this).parents('.hover_effect_expansion').siblings().find('.child_2').slideUp("slow");         
    });

    $(".hover_effect_overlay").hover(function(){
        var offset = '-'+ $('.child_1',this).width()+'px';
        $(".child_2",this).stop().animate({top:'0',left:offset},{queue:false,duration:400});
    },function(){
        $(".child_2",this).stop().animate({top:'0px',left:'0px'},{queue:false,duration:400});
    });
    
    $(".hover_effect_popup").hover(function(e){
        var self = $(this); var child1 = $(".child_1",this); var child2 = $(".child_2",this);
        var p = self.parent().width()/2 - self.position().left - self.width();
        var offset = child1.offset();
        // get silbings, get parent.width, get current 
        // get currentTarge.pageX, 
        var position = []; // top, left
        var block =  $(window);
        var scroll_top = block.scrollTop();
        var scroll_left = block.scrollLeft();
        if ( p>=0 ){ // pop up on right side of child2
          position[0] = offset.top - ( child2.height() - child1.height() )/2 - scroll_top;
          position[1] = offset.left + child1.width() ;
        }else{ // pop up on left side of self
          position[0] = offset.top - ( child2.height() - child1.height() )/2 - scroll_top;            
          position[1] =  offset.left - child2.width() ;
        }
        //console.log( "pos y=%d, x=%d", position[0], position[1] );
        $(".child_2",this).simplemodal({modal:false,focus:false, position: position, fixed:false });
    },function(){ $.simplemodal.close();  
      });
});
