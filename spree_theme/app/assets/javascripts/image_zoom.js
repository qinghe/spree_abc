/*
 * The image zoom plugin references the jQzoom plugin, and remove the features not be used.
 * Make the code be simple. 
 * 
 * Colin Ju
 *
 * jQzoom Evolution Library v2.3  - Javascript Image magnifier
 * http://www.mind-projects.it
 *
 * Copyright 2011, Engineer Marco Renzi
 * Licensed under the BSD license.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the organization nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * Date: 03 May 2011 22:16:00
 */
(function($) {
	var _config = {
		thumbConfig: {
			containerSelector: '',
			unitSelector: 'a',
			eventName: 'click',
			attr: 'rel',
			activeClassName: 'thumb-active'
		},
		zoomPadConfig: {
			containerSelector: ''
		},
		zoomViewerConfig: {
			width: 300,
			height: 300
		},
		largeImageContainerSelector: ''
	};
	
	var isIE6 = (!$.support.opacity && !$.support.style && window.XMLHttpRequest==undefined),
		doc = document,
		win = window,
		jWin = $(win),
		min = Math.min;
	
	/***
	 * Define custom event
	 */
	var CustomEvent = {
		eventObj: $({}),
		bind: function() {
			this.eventObj.bind.apply(this.eventObj, arguments);
		},
		trigger: function() {
			this.eventObj.trigger.apply(this.eventObj, arguments);
		},
		unbind: function() {
			this.eventObj.unbind.apply(this.eventObj, arguments);
		}
	};
	/**
	 * add image zoom to jquery plugin
	 */
	$.fn.imageZoom = function(config) {
		return this.each(function () {
			new ImageZoom(this, config);
		});
	};
	
	/**
	 * The image zoom component entry.
	 */
	var ImageZoom = function(container, config) {
		var jContainer = $(container);
		if (jContainer.data('inited') === 'y') {//Init image zoom only one time.
			return;
		}
		this.jContainer = jContainer;
		this.config = $.extend(true, _config, config || {}); //Deep copy.
		this._init();
		jContainer.data('inited', 'y');
	};
	
	$.extend(ImageZoom.prototype, {
		constructor: ImageZoom,
		_init: function() {
			//Init the zoom pad component
			var config = this.config,
				zoomPadConfig = config.zoomPadConfig;
				
			new ZoomPad(this.jContainer.find(zoomPadConfig.containerSelector), zoomPadConfig, config.zoomViewerConfig);
			
			var thumbConfig = config.thumbConfig;
			//if there is thumb list, init it.
			if (thumbConfig && thumbConfig.containerSelector) {
				var jThumbContainer = this.jContainer.find(thumbConfig.containerSelector);
				
				if (jThumbContainer.length) {
					new ThumbList(jThumbContainer, thumbConfig);
				}
			}
		}
	});
	
	/**
	 * The thumbnail list component
	 */
	var ThumbList = function(jContainer, config) {
		this.jContainer = jContainer;
		this.config = config;
		this._init();
	};
	
	$.extend(ThumbList.prototype, {
		constructor: ThumbList,
		_init: function() {
			this.dActiveUnit = this.jContainer.find(this.config.unitSelector).get(0);
			this._bindEvent();
		},
		_bindEvent: function() {
			var _this = this,
				config = this.config;
			
			this.jContainer.delegate(config.unitSelector, config.eventName, function(event) {
				var jThis = $(this),
					activeClassName,
					oImagesSrc = eval('(' + $.trim(jThis.attr(config.attr)) + ')');
				
				if (_this.dActiveUnit !== this) {
					activeClassName = config.activeClassName;
					$(_this.dActiveUnit).removeClass(activeClassName);
					jThis.addClass(activeClassName);
					_this.dActiveUnit = this;
					CustomEvent.trigger('thumb-unit-active', oImagesSrc);
				}
			});
		}
	});
	
	/**
	 * The zoom pad component
	 */
	var ZoomPad = function(jContainer, zoomPadConfig, zoomViewerConfig) {
    this.jBody = $(doc.body) // get body in function, body may not ready when loading this file 
		this.jContainer = jContainer;
		this.zoomPadConfig = zoomPadConfig;
		this.zoomViewerConfig = zoomViewerConfig;
		this._init();
	};
	
	$.extend(ZoomPad.prototype, {
		constructor: ZoomPad,
		_init: function() {
			this.largeImageLoading = false;
			this.largeImageLoaded = false;
			this.smallImageData = null;
			this.largeImageData = null;
			this.jZoomLens = null;
			this.jZoomViewer = null;
			this.jIframe = null;
			this.jSmallImage = this.jContainer.find('img');
			this.jSmallImageParent = this.jSmallImage.parent();
			this.jLargeImage = this._createLargeImage();
			this.jLoading = null;
			this.eventPos = null;
			this.isHover = false;
			this.lensL = 0;
			this.lensT = 0;
			this._bindEvent();
			if (this.jSmallImage[0].complete) {//sometimes the image is loaded and the onload will not be fired.
				this.smallImageLoaded = true;
				this._fetchSmallImageData();
			}
		},
		_bindEvent: function() {
			var _this = this;
			
			this.jSmallImage.load(function() {
				_this._fetchSmallImageData();
			}).error(function() {
				//TODO
			}).hover(function(e) {
				_this.isHover = true;
				if (!_this.largeImageLoaded && !_this.largeImageLoading) {
					_this._showLoading(true);
          //_this._loadLargeImage(_this.jSmallImageParent.attr('href'));
          _this._loadLargeImage(_this.jSmallImage.data('big-image'));
				}
				_this.eventPos = {
					pageX: e.pageX,
					pageY: e.pageY
				};
			}, function() {
				_this.isHover = false;
			});
			
			this.jSmallImageParent.hover(function() {
				//TODO
			}, function() {
				_this._hideMoveZoomLens();
			}).click(function(e) {
				return false;
			}).mousemove(function(e) {
				_this.eventPos = {
					pageX: e.pageX,
					pageY: e.pageY
				};
				
				if (_this.largeImageLoaded) {
					var oScale = _this._getScale();
					if (oScale.x > 1 || oScale.y > 1) {
						_this._moveZoomLens(_this._countLensSizeAndPos());
					}
				}
			});
			this.jLargeImage.load(function() {
				_this.largeImageLoaded = true;
				_this.largeImageLoading = false;
				_this._showLoading(false);
				_this._fetchLargeImageData();
				
				var oScale = _this._getScale();
				if (_this.isHover && (oScale.x > 1 || oScale.y > 1)) {
					_this._moveZoomLens(_this._countLensSizeAndPos());
				}
			}).error(function() {
				_this.largeImageLoading = false;
				_this._showLoading(false);
			});
			CustomEvent.bind('thumb-unit-active', function(event, oImagesSrc) {
				_this.smallImageData = null;
				_this.largeImageData = null;
				_this.oScale = null;
				_this.largeImageLoaded = false;
				_this.largeImageLoading = false;
				_this.jSmallImage.attr('src', oImagesSrc.smallimage).parent().attr('href', oImagesSrc.largeimage);
			});
		},
		_createLargeImage: function() {
			var jLargeImage = $(new Image());
			
			jLargeImage.hide().appendTo(this.jBody);
			return jLargeImage;
		},
		_loadLargeImage: function(src) {
			this.largeImageLoaded = false;
			this.largeImageLoading = true;
			this.jLargeImage.attr('src', src);
		},
		_fetchSmallImageData: function() {
			var jSmallImage = this.jSmallImage,
				offset = jSmallImage.offset();
				
			this.smallImageData = {
				w: jSmallImage.width(),
				h: jSmallImage.height(),
				t: offset.top,
				l: offset.left,
				borderT: parseInt(jSmallImage.css('border-top-width').replace('px', '')),
				borderL: parseInt(jSmallImage.css('border-left-width').replace('px', '')),
				borderR: parseInt(jSmallImage.css('border-right-width').replace('px', ''))
			};
		},
		_fetchLargeImageData: function() {
			this.largeImageData = {
				w: this.jLargeImage.width(),
				h: this.jLargeImage.height()
			}
		},
		_getScale: function() {
			return {
				x: this.largeImageData.w/this.smallImageData.w,
				y: this.largeImageData.h/this.smallImageData.h
			};
		},
		_countLensSizeAndPos: function() {
			//the lens's position is relatived to image's parent.
			var zoomViewerConfig = this.zoomViewerConfig,
				oScale = this._getScale(),
				smallImageData = this.smallImageData,
				w = min(parseInt(zoomViewerConfig.width / oScale.x), smallImageData.w),
				h = min(parseInt(zoomViewerConfig.height / oScale.y), smallImageData.h),
				eventPos = this.eventPos,
				pageX = eventPos.pageX,
				pageY = eventPos.pageY,
				x = pageX - smallImageData.l - smallImageData.borderL,
				y = pageY - smallImageData.t - smallImageData.borderT,
				lensL = pageX - smallImageData.l - w/2, 
				lensT = pageY - smallImageData.t - h/2;
				
			if (x - w/2 <= 0) {
				lensL = smallImageData.borderL;
			} else if (x + w/2 >= smallImageData.w) {
				lensL = smallImageData.w - w + smallImageData.borderL;
			}
			if (y - h/2 <= 0) {
				lensT = smallImageData.borderT;
			} else if (y + h/2 >= smallImageData.h) {
				lensT = smallImageData.h - h + smallImageData.borderT;
			}
			this.lensL = lensL;
			this.lensT = lensT;
			return {
				width: w,
				height: h,
				top: lensT,
				left: lensL
			};
		},
		_showLoading: function(isShow) {
			var smallImageData = this.smallImageData;
			
			this.jLoading = this.jSmallImageParent.find('div.zoom-loading');
			if (this.jLoading.length === 0) {
				this.jLoading = $('<div class="zoom-loading"></div>').appendTo(this.jSmallImageParent);
			}
			if (isShow) {//show loading
				this.jLoading.css({
					left: (this.jSmallImageParent.width() - this.jLoading.width())/2,
					top: (this.jSmallImageParent.height() - this.jLoading.height())/2
				}).show();
			} else {//hide loading
				this.jLoading.hide();
			}
		},
		_moveZoomLens: function(oSizeAndPos) {
			this.jZoomLens = this.jSmallImageParent.find('div.zoom-lens');
			if (this.jZoomLens.length === 0) {
				this.jZoomLens = $('<div class="zoom-lens"></div>').appendTo(this.jSmallImageParent);
			}
			this.jZoomLens.css(oSizeAndPos).show();
			this._showZoomViewer();
		},
		_hideMoveZoomLens: function() {
			if (this.jZoomLens) {
				this.jZoomLens.hide();
			}
			this._hideZoomViewer();
		},
		_isInImageArea: function() {
			var smallImageData = this.smallImageData,
				eventPos = this.eventPos,
				pageX = eventPos.pageX,
				pageY = eventPos.pageY;
			
			return (pageX >= smallImageData.l + smallImageData.borderL && 
					pageX <= smallImageData.l + smallImageData.borderL + smallImageData.w &&
					pageY >= smallImageData.t + smallImageData.borderT &&
					pageY <= smallImageData.t + smallImageData.borderT + smallImageData.h
				) ? true : false;
		},
		_showZoomViewer: function() {
			var smallImageData = this.smallImageData,
				oScale = this._getScale(),
				jImage,
				imageSrc = this.jSmallImage.data('big-image');
        //imageSrc = this.jSmallImageParent.attr('href');

			this.jZoomViewer = this.jBody.find('div.zoom-viewer');
			if (this.jZoomViewer.length === 0) {
				this.jZoomViewer = $('<div class="zoom-viewer"><img src=""/></div>').css(this.zoomViewerConfig).appendTo(this.jBody);
			}
			if (isIE6) {
				this.jIframe = this.jBody.find('iframe.zoom-iframe');
				if (this.jIframe.length === 0) {
					this.jIframe = $('<iframe class="zoom-iframe" src="javascript:\'\';" marginwidth="0" marginheight="0" align="bottom" scrolling="no" frameborder="0"></iframe>').css(this.zoomViewerConfig).appendTo(this.jBody);
				}
				this.jIframe.show();
			}
			
			this.jZoomViewer.css({
				left: smallImageData.l + smallImageData.borderL + smallImageData.w + smallImageData.borderR + 10,
				top: smallImageData.t
			}).show();
			jImage = this.jZoomViewer.find('img');
			if (this.jZoomViewer.find('img').attr('src') !== imageSrc) {
				jImage.attr('src', imageSrc);
			}
			jImage.css({
				left: -((this.lensL -  smallImageData.borderL) * oScale.x),
				top: -((this.lensT - smallImageData.borderT)* oScale.y)
			});
		},
		_hideZoomViewer: function() {
			if (this.jZoomViewer) {
				this.jZoomViewer.hide();
			}
			if (this.jIframe) {
				this.jIframe.hide();
			}
		}
	});
})(jQuery);