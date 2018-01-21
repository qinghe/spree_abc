//= require jweixin-1.1.0
//= require store/weixin_support

if( g_client_info.is_wechat && getstore.wx_cfg_params ){
  wx.config({
    debug: getstore.wx_cfg_params.debug,
    appId: getstore.wx_cfg_params.app_id,
    timestamp:  getstore.wx_cfg_params.timestamp,
    nonceStr:  getstore.wx_cfg_params.nonce_str,
    signature:  getstore.wx_cfg_params.signature,
    jsApiList:  getstore.wx_cfg_params.js_api_list
  });

  wx.ready(function () {
    wx.onMenuShareTimeline({
      title:  getstore.share_data.desc,
      desc:getstore.share_data.title,
      link:   getstore.share_data.link,
      imgUrl: getstore.share_data.imgUrl,
      success: function () {
              },
      cancel: function () {
      }
    });
    wx.onMenuShareAppMessage({
      title: getstore.share_data.title,
      desc: getstore.share_data.desc,
      link:  getstore.share_data.link,
      imgUrl: getstore.share_data.imgUrl,
      type: '',
      dataUrl: '',
      success: function () {
      },
      cancel: function () {
      }
    });
  });

}
