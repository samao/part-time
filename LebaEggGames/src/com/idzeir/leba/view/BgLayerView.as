package com.idzeir.leba.view
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class BgLayerView extends Sprite
	{
		private var loader:Loader = new Loader();
		private var _url:URLRequest = new URLRequest();
		
		public function BgLayerView()
		{
			super();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onReady);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
		}
		
		protected function errorHandler(event:IOErrorEvent):void
		{
			this.dispatchEvent(new Event("IOError"));
		}
		
		protected function onReady(event:Event):void
		{
			this.removeChildren();
			var bitmap:Bitmap = event.target.content as Bitmap;
			if(bitmap)
			{
				bitmap.width = stage.stageWidth;
				bitmap.height = stage.stageHeight;
				this.addChild(bitmap);
			}
		}
		
		public function set url(value:String):void
		{
			_url.url = value;
			loader.unloadAndStop();
			loader.load(_url);
		}
	}
}