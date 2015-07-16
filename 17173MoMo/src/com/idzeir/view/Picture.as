package com.idzeir.view
{
	import com.idzeir.vo.RoomInfoVo;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;


	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Nov 29, 2014 10:56:04 AM
	 *
	 **/

	public class Picture extends Sprite
	{
		private var _url:URLRequest;
		private var loader:Loader;

		private var byte:URLLoader;

		private const W:int = 200;
		private const H:int = 150;

		public function Picture()
		{
			super();

			this.mouseChildren = false;
			this.mouseEnabled = false;

			_url = new URLRequest();
			_url.idleTimeout = 10000;
			loader = new Loader();
			byte = new URLLoader();

			byte.dataFormat = URLLoaderDataFormat.BINARY;
			byte.addEventListener(IOErrorEvent.IO_ERROR, onError);
			byte.addEventListener(Event.COMPLETE, onBytesReady);
			byte.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			this.graphics.beginFill(0x323232, 1);
			this.graphics.drawRect(0, 0, W, H);
			this.graphics.endFill();

			var color:int = 0x000000;
			this.filters = [new flash.filters.DropShadowFilter(1, 0, color, .2), new DropShadowFilter(4, 90, color, .4), new DropShadowFilter(1, 180, color, .2)]
		}

		protected function onBytesReady(event:Event):void
		{
			var ldr:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			ldr.allowCodeImport = true;
			loader.loadBytes(event.target.data, ldr);
		}

		protected function onError(event:Event):void
		{
			//trace("加载错误:" + _url.url, event);
		}

		protected function onComplete(event:Event):void
		{
			var bitmap:Bitmap = event.target.content as Bitmap;
			bitmap.width = W;
			bitmap.height = H;
			this.addChild(bitmap);
		}

		public function set roomvo(value:RoomInfoVo):void
		{
			url = value.photo;
		}

		public function set url(value:String):void
		{
			_url.url = value;
			byte.load(_url);
		}
	}
}