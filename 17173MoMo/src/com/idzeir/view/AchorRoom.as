package com.idzeir.view
{
	import com.idzeir.assets.videoBglayer;
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.events.InfoEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.H264VideoStreamSettings;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	
	/**
	 * 播放房间内部ui
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class AchorRoom extends Sprite implements IRender
	{
		private var _rtmp:String;
		private var _stream:String;


		private var _nc:NetConnection;
		private var _ns:NetStream;

		private var _video:Video;

		private var _bglayer:Bitmap;

		private var vol:Number;
		
		private var _tips:WeakTips;

		private var videolayer:Sprite;

		public function AchorRoom()
		{
			super();
			this.mouseEnabled = false;
			//this.mouseChildren = false;
			_bglayer = new Bitmap(new videoBglayer(), "auto", true);
			this.addChild(_bglayer);

			videolayer = new Sprite();
			this.addChild(videolayer);
			_video ||= new Video(480, 360);
			_video.smoothing = true;
			_video.deblocking = 2;
			videolayer.addChild(_video);

			this.addEventListener(Event.ADDED_TO_STAGE, function():void
				{
					resize();
				});
			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(e:InfoEvent):void
				{
					e.info.code == Enum.ACTION_PlAY_STREAM && playStream(e.info.data);
				});

			vol = 1;
			
			var author:TextField = new TextField();
			author.defaultTextFormat = new TextFormat("微软雅黑", 12, null, false);
			author.autoSize = "left";
			author.htmlText = "<font color='#ffffff'>qiyanlong@WoZine.com</font>";
			var bmd:BitmapData = new BitmapData(author.width, author.height, true, 0x00ffffff);
			bmd.draw(author);
			var bitmap:Bitmap = new Bitmap(bmd, "auto", true);
			this.addChild(bitmap);
			bitmap.rotation = -45;
			bitmap.y = 120;
			bitmap.alpha = .4;
			bitmap.filters = [new GlowFilter(0xff0000, 1, 1, 1, 1)];
			
			var beginTouch:Point = new Point();
			videolayer.addEventListener(TouchEvent.TOUCH_BEGIN,function(e:TouchEvent):void
			{
				beginTouch.x = e.localX;
				beginTouch.y = e.localY;
			});
			videolayer.addEventListener(TouchEvent.TOUCH_END,function(e:TouchEvent):void
			{
				var offY:Number = e.localY - beginTouch.y;
				var precent:Number = Math.min(_video.height,Math.abs(offY))/_video.height;
				vol -=precent*(Math.abs(offY)/offY);
				vol = Math.min(1,vol);
				vol = Math.max(0,vol);
				volume = vol;
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_SHOW_TIPS, data:"音量:" + uint(vol * 100)}));
			});
			
			_tips = new WeakTips();
			this.addChild(_tips);
		}

		private function playStream(value:Object):void
		{
			_rtmp = value.connectionURL;
			_stream = value.streamName;
			_nc ||= new NetConnection();

			_nc.client = {};
			if (_ns)
			{
				try
				{
					_ns.dispose();
				}
				catch (e:Error)
				{
					
				}
			}
			if (_nc.hasEventListener(NetStatusEvent.NET_STATUS))
			{
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, netHandler);
			}
			if (_nc.connected)
			{
				_nc.close();
			}
			_nc.addEventListener(NetStatusEvent.NET_STATUS, netHandler);
			try
			{
				_nc.connect(_rtmp);
			}
			catch (er:Error)
			{
				trace(er);
			}
		}

		protected function netHandler(event:NetStatusEvent):void
		{
			trace(event.info.code);
			if (event.info.code == "NetConnection.Connect.Success")
			{
				_ns = new NetStream(_nc);
				_ns.client = {};
				volume = vol;
				//_ns.videoStreamSettings = new flash.media.H264VideoStreamSettings();
				//_ns.useHardwareDecoder = true;
				//_ns.useJitterBuffer = true;
				//_ns.receiveVideoFPS(10);
				_ns.play(_stream);
				_video.attachNetStream(_ns);
				
				resize();
			}
			else
			{
				//_stream = null;
				//_rtmp = null;
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_SHOW_TIPS, data:event.info.code + " [InitRtmp]"}));
			}
		}
		
		public function set volume(value:Number):void
		{
			vol = value;
			if(_ns)
			{
				var st:SoundTransform = _ns.soundTransform;
				st.volume = vol;
				_ns.soundTransform = st;
			}
		}

		public function get warp():DisplayObject
		{
			return this;
		}

		public function resize():IRender
		{
			if (_video)
			{
				_bglayer.width = stage.fullScreenWidth;
				_bglayer.height = (400 * stage.fullScreenWidth / G.WIDTH);

				var ratio:Number = stage.fullScreenWidth / G.WIDTH;
				var lefAndRig:Number = 60 * ratio;
				var vPer:Number = (stage.fullScreenWidth - lefAndRig) / G.WIDTH;
				_video.width = G.WIDTH * vPer
				_video.height = 360 * vPer;
				_video.x = stage.fullScreenWidth - _video.width >> 1;
				_video.y = 53 * ratio;
				videolayer.graphics.endFill();
				videolayer.graphics.beginFill(0,0);
				videolayer.graphics.drawRect(_video.x,_video.y,_video.width,_video.height);
				videolayer.graphics.endFill();
				
				_tips.resize();
				_tips.y =( _video.height - _tips.height>>1)+_video.y;
			}
			return this;
		}
	}
}