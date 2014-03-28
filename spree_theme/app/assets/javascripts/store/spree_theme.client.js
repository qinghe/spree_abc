//= require jquery.validate/localization/messages_zh-CN.js
function center_template_section( selector )
{
  var ele = $(selector);
  ele.css("top", ($('#page').height() - ele.outerHeight(true)) / 2 + $('#page').scrollTop() + "px");
  ele.css("left", ($('#page').width() - ele.outerWidth(true)) / 2 + $('#page').scrollLeft() + "px");
  ele.show();
}