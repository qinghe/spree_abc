//= require jquery.validate/localization/messages_zh-CN.js
function center_template_section( selector )
{
    var ele = $(selector);
    ele.css("top", ($('#page').height() - ele.outerHeight(true)) / 2 + $('#page').scrollTop() + "px");
    ele.css("left", ($('#page').width() - ele.outerWidth(true)) / 2 + $('#page').scrollLeft() + "px");
    ele.show();
}


$(document).ready(function() {
  // template theme selection for designer shop
  $( "#embeded_content_wrapper" ).hover(
    function() { $(this).show(); $( "#embeded_content_wrapper_icon" ).hide();},
    function() { $(this).hide(); $( "#embeded_content_wrapper_icon" ).show();}
  );
  $( "#embeded_content_wrapper_icon" ).hover(
    function() { $( "#embeded_content_wrapper" ).show(); }
  );
    
});

// copy from project https://github.com/citrus/spree_variant_options
// params:
//   view_style: 'slide',null
//   options:  { option_id=>{ option_value_id=>{ variant_id=>variant } } }
//   allow_select_outofstock: By setting allow_select_outofstock to true, when an user selects variant options it will automatically update any form's input variant_id with an data-form-type="variant" attribute.
//   default_instock: (default: false) If this is option is set to true, it will automatically preselect in-stock variant options.
function VariantOptions(params) {
    var view_style = params['view_style']
    var options = params['options'];
    var container_selector = params['container_selector']
    var allow_backorders = !params['track_inventory_levels'] ||  params['allow_backorders'];
    var allow_select_outofstock = params['allow_select_outofstock'];
    var default_instock = params['default_instock'];

    var variant, option_types, option_values_container, index = 0;
    // option_types: all option_types included option_values
    // option_values_container: a container for  option_values of an option_type
    var available_variant_ids = []; // base on selected option value, there are some available variant ids 
    var buttons;


    function init() {
        option_types = $('#product-variants .variant-options');
        disable(option_types.find('a.option-value').addClass('locked'));
        update();
        enable(option_values_container.find('a.option-value'));
        toggle();
        option_types.find('a.option-value').click(handle_click);

        if (default_instock) {
            option_types.each(function(){
                $(this).find("ul.variant-option-values li a.in-stock:first").click();
            });
        }
    }

    // update data, option_values_container,buttons
    function update(i) {
        index = isNaN(i) ? index : i;
        option_values_container = $(option_types.get(index));
        buttons = option_values_container.find('a.option-value');
    }

    function disable(btns) {
        return btns.removeClass('selected');
    }
    // enable option values of current option type
    function enable(btns) {
        var bt = btns.not('.unavailable').removeClass('locked')
        if (!allow_select_outofstock && !allow_backorders){
            bt = bt.filter('.in-stock')
        }            
        return bt.filter('.auto-click').removeClass('auto-click').click();
    }

    function advance() {
        index++
        update();
        inventory(buttons.removeClass('locked'));
        enable(buttons);
    }


    function toggle() {
        if (variant) {
            $('#variant_id, form[data-form-type="variant"] input[name$="[variant_id]"]').val(variant.id);
            $('#product-price .price').removeClass('unselected').text(variant.price);
            if (variant.count > 0 || allow_backorders)
                $('#cart-form button[type=submit]').attr('disabled', false).fadeTo(100, 1);
            $('form[data-form-type="variant"] button[type=submit]').attr('disabled', false).fadeTo(100, 1);
            try {
                show_variant_images(variant.id);
            } catch(error) {
                // depends on modified version of product.js
            }
        } else {
            $('#variant_id, form[data-form-type="variant"] input[name$="[variant_id]"]').val('');
            $('#cart-form button[type=submit], form[data-form-type="variant"] button[type=submit]').attr('disabled', true).fadeTo(0, 0.5);
            var price = $('#product-price .price').addClass('unselected')
            // Replace product price by "(select)" only when there are at least 1 variant not out-of-stock
            variants = $("div.variant-options.index-0")
            if (variants.find("a.option-value.out-of-stock").length != variants.find("a.option-value").length)
                price.text('(select)');
        }
    }

    function clear(i) {
        variant = null;
        update(i);
        enable(buttons.removeClass('selected'));
        toggle();
        option_values_container.nextAll().each(function(index, element) {
            disable($(element).find('a.option-value').show().removeClass('in-stock out-of-stock').addClass('locked'));
        });
        hide_all_variant_images();
    }

    function handle_click(evt) {
        evt.preventDefault();
        variant = null;
        available_variant_ids = [];
        var a = $(this);
        //return if has class unavailable locked
        if( a.hasClass("unavailable") || a.hasClass("locked")){
            return
        }
        //if (!allow_select_outofstock && !allow_backorders){
        //    bt = bt.filter('.in-stock')
        //}            
        
        if (a.filter('.selected').length>0){
            // unclick selected, 
            clear(option_types.index(a.parents('.variant-options:first')));
        }else{
            if (!option_values_container.has(a).length) {
                clear(option_types.index(a.parents('.variant-options:first')));
            }
            disable(buttons);
            var a = enable(a.addClass('selected'));
            advance();
            if (find_variant()) {
                toggle();
            }            
        }        
    }


    function show_variant_images(variant_id) {
        $('li.vtmb').hide();
        $('li.tmb-' + variant_id).show();
        var currentThumb = $('#' + $("#main-image").data('selectedThumbId'));
        // if currently selected thumb does not belong to current variant, nor to common images,
        // hide it and select the first available thumb instead.
        if(!currentThumb.hasClass('tmb-' + variant_id)) {
            //var thumb = $($('ul.thumbnails li:visible').eq(0));
            var thumb = $($("ul.thumbnails li.tmb-" + variant_id + ":first").eq(0));
            if (thumb.length == 0) {
                thumb = $($('ul.thumbnails li:visible').eq(0));
            }
            var newImg = thumb.find('a').attr('href');
            $('ul.thumbnails li').removeClass('selected');
            thumb.addClass('selected');
            $('#main-image img').attr('src', newImg);
            $("#main-image").data('selectedThumb', newImg);
            $("#main-image").data('selectedThumbId', thumb.attr('id'));
        }
    }

    function show_all_variant_images() {
        $('li.vtmb').show();
    }
    function hide_all_variant_images() {
        $('li.vtmb').hide();
    }
    
    function inventory(btns) {
      // for each option_value there is collection of available variants
      // given option_values, Intersection of those collections is final available variants   
        var variant_ids, variants, count = 0, selected = {};
        var sels = $.map(option_types.find('a.selected'), function(i) { return i.rel });
        $.each(sels, function(i, value) {
            var ids = value.split('-');
            var variant_id_variant_hash = options[ids[0]][ids[1]];
            variant_ids = get_keys_of_object( variant_id_variant_hash );
            var m = find_same_in_array(available_variant_ids.concat(variant_ids));
            if (available_variant_ids.length == 0) {// first time available_variant_ids.length == 0
                available_variant_ids = variant_ids;
            } else if (m) {
                available_variant_ids = m;
            }
        });
        btns.removeClass('in-stock out-of-stock unavailable').each(function(i, element) {
            variants = get_variant_objects(element.rel, available_variant_ids);
            variant_ids = get_keys_of_object(variants);
            if (variant_ids.length == 0) {
                disable($(element).addClass('unavailable locked'));
            } else if (variant_ids.length == 1) {
                var _var = variants[variant_ids[0]];
                $(element).addClass((allow_backorders || _var.count) ? available_variant_ids.length == 1 ? 'in-stock auto-click' : 'in-stock' : 'out-of-stock');
            } else if (allow_backorders) {
                $(element).addClass('in-stock');
            } else {
                $.each(variants, function(key, value) { count += value.count });
                $(element).addClass(count ? 'in-stock' : 'out-of-stock');
            }
        });
    }

    //==========================================================================================
    // method for slide style
    //------------------------------------------------------------------------------------------
    function init_for_slide_style() {
        option_types = $(container_selector+" .variant-option");
        option_types.find('a.option-value').click( handle_click_for_slide_style );        
        $(container_selector+' button.next').click( next_step_click );
        $(container_selector+' button.back').click( back_step_click );
        
        initialize_option_view();
    }

    function initialize_option_view (i) {
        index = isNaN(i) ? index : i;
        option_types.hide();
        update_model();
        //keep selected before
        if( option_values_container.find("a.option-value.selected").length == 0)  {
          option_values_container.find("a.option-value:first").click();
        }
        option_values_container.show()     
    }
    // update
    // update data, option_values_container,buttons
    function update_model() {
        option_values_container = $(option_types.get(index));
        buttons = option_values_container.find('a.option-value');
    }
    
    // update price?    
    function update_view() {
        //show 
        var option_type_id_and_option_value_id =  buttons.filter('.selected').attr('rel').split('-');
        option_values_container.find(' .olge').hide();
        option_values_container.find(' .lge-'+option_type_id_and_option_value_id[1]).show();
    }
    
    function next_step_click() {
        index++;
        initialize_option_view();
    }
    
    function back_step_click() {
        index--;
        initialize_option_view();
    }
        
    function handle_click_for_slide_style(evt) {
        evt.preventDefault();
        var a = $(this);
        //return if has class unavailable locked
        if( a.hasClass("unavailable") || a.hasClass("locked")|| a.hasClass("selected")){
            return
        }          
        buttons.not(a).removeClass('selected');
        a.addClass('selected');
        
        update_view();
        
        find_variant();
        
    }
    //                                end slide style
    //==========================================================================================
    
    //==========================================================================================
    // common method for option value
    //------------------------------------------------------------------------------------------
    
    // for object, it return property names
    // for array, it return indexes
    function get_keys_of_object(obj){
        var a = [];
        $.each(obj, function(i){ a.push(i) });
        return a;
    }
    
    function index_of_array(array, obj) {
        for(var i = 0; i < array.length; i++){
            if(array[i] == obj) {
                return i;
            }
        }
        return -1;
    }
    
    function find_same_in_array(a) {
        var i, m = [];
        a = a.sort();
        i = a.length
        while(i--) {
            if (a[i - 1] == a[i]) {
                m.push(a[i]);
            }
        }
        if (m.length == 0) {
            return false;
        }
        return m;
    }
    
    function to_f(string) {
        return parseFloat(string.replace(/[^\d\.]/g, ''));
    }

    function get_available_variant_ids(){
        var selected = option_types.find('a.selected');
              
    }

    function find_variant() {
        var selected = option_types.find('a.selected');
        var variants = get_variant_objects(selected.get(0).rel, available_variant_ids);
        if (selected.length == option_types.length) {
            return variant = variants[available_variant_ids[0]];
        } else {
            var prices = [];
            $.each(variants, function(key, value) { prices.push(value.price) });
            prices = $.unique(prices).sort(function(a, b) {
                return to_f(a) < to_f(b) ? -1 : 1;
            });
            if (prices.length == 1) {
                $('#product-price .price').html('<span class="price assumed">' + prices[0] + '</span>');
            } else {
                $('#product-price .price').html('<span class="price from">' + prices[0] + '</span> - <span class="price to">' + prices[prices.length - 1] + '</span>');
            }
            return false;
        }
    }

    function get_variant_objects(rels, scoped_variant_ids) {
        var i, ids, obj, variants = {};
        if (typeof(rels) == 'string') { rels = [rels]; }
        var otid, ovid, opt, opv;
        i = rels.length;
        try {
            while (i--) {
                ids = rels[i].split('-');
                otid = ids[0];
                ovid = ids[1];
                opt = options[otid];
                if (opt) {
                    opv = opt[ovid];
                    ids = get_keys_of_object(opv);
                    if (opv && ids.length) {
                        var j = ids.length;
                        while (j--) {
                            obj = opv[ids[j]];
                            if (obj && get_keys_of_object(obj).length && 0 <= index_of_array(scoped_variant_ids,obj.id.toString())) {
                                variants[obj.id] = obj;
                            }
                        }
                    }
                }
            }
        } catch(error) {
            //console.log(error);
        }
        return variants;
    }


    //                               end common methods 
    //==========================================================================================

    
    if( view_style == 'slide' ){
      $(document).ready(init_for_slide_style);      
    }else{
      $(document).ready(init);
    }
};
