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
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
		
		private var _pressPos:Point;

		private var _tips:WeakTips;

		public function AchorRoom()
		{
			super();
			//this.mouseEnabled = false;
			this.mouseChildren = false;
			_bglayer = new Bitmap(new videoBglayer(), "auto", true);
			_bglayer.opaqueBackground = true;
			this.addChild(_bglayer);

			_video ||= new Video(480, 360);
			_video.smoothing = true;
			_video.deblocking = 2;
			this.addChild(_video);

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
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onPress);
			
			_tips = new WeakTips();
			this.addChild(_tips);
		}

		protected function onPress(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			_pressPos ||= new Point();
			_pressPos.x = mouseX;
			_pressPos.y = mouseY;
		}

		protected function onRelease(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
			var _releasePos:Point = new Point(mouseX, mouseY);
			var dis:int = Point.distance(_releasePos, _pressPos);
			var inReduce:Boolean = _releasePos.y > _pressPos.y;

			var detal:Number = Math.min(dis, _video.height) / (_video.height);
			if (inReduce)
			{
				vol -= detal;
				vol = Math.max(0, vol);
			}
			else
			{
				vol += detal;
				vol = Math.min(1, vol);
			}
			volume = vol;

			G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_SHOW_TIPS, data:"音量:" + uint(vol * 100)}));
		}
		
		private function playStream(value:String):void
		{
			var index:int = value.lastIndexOf("/");
			/*if (value.substr(index + 1) == _stream)
			{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_SHOW_TIPS, data:"播放中"}));
				return;
			}*/
			_rtmp = value.substring(0, index);
			_stream = value.substr(index + 1);
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
				_ns.useHardwareDecoder = false;
				_ns.useJitterBuffer = true;
				_ns.receiveVideoFPS(10);
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
				
				_tips.resize();
				_tips.y =( _video.height - _tips.height>>1)+_video.y;
			}
			return this;
		}
	}
}