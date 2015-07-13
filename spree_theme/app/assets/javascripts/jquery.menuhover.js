// a hover event as amazon
// by yilizhang@sohu-inc.com

(function($) {

    $.fn.menuhover = function(opts) {

        this.each(function() {
            init.call(this, opts);
        });

        return this;
    };

    function init(opts) {
        var $menuhover = $(this),
            timeoutId = null,
            options = $.extend({
                submenuDirection: "below",
                activate: $.noop,
                deactivate: $.noop,
                $hover:null,
                $hover_effect_container: $menuhover
            },opts),
            $hover = options.$hover;

        var MOUSE_LOCS_TRACKED = 3,
            DELAY = 200;


        function mouseenter(e){
            options.activate();
            //e.stopPropagation();
        }

        function mouseleave(e){
            if(inArea(e)){
                timeoutId = setTimeout(function() {
                    options.deactivate();
                }, DELAY);
            }else{
                options.deactivate();
            }
        }

        function mouseenterHover(){
            if (timeoutId) {
                // Cancel any previous activation delays
                clearTimeout(timeoutId);
            }
        }

        function inArea(e){
            var offset = $menuhover.offset();
            if( options.submenuDirection=='b'){
                // y+menuhover.height, disable case mouse move from one menu itme to next menu item.
                if( e.pageX >= offset.left && e.pageY >= (offset.top + $menuhover.height())){ // mouse move to right bottom 
                    return true;
                }
            }else{
                if( e.pageX <= offset.left && e.pageY >= offset.top){ // mouse move to left bottom
                    return true;
                }                
            }
                
            return false;
        }

        $menuhover.mouseenter(mouseenter)
                  .mouseleave(mouseleave);
        $hover.mouseenter(mouseenterHover);
        // hover is not in element menuhover, mouseleave is required.
        $hover.mouseleave(mouseleave);
    }

})(jQuery);
