$(document).ready(function() {
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
         $(this).next(".child_2").slideDown(500);
         $(this).parents('.hover_effect_expansion').siblings().find('.child_2').slideUp("slow");         
    });

});
