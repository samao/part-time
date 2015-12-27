package com.idzeir.flashviewer.module.guide
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	
	/**
	 * ...
	 * @author: iDzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Dec 27, 2015 4:31:45 PM
	 *
	 **/
	
	public class HelpView extends Sprite
	{
		private var _url:URLRequest = new URLRequest();
		private var loader:Loader = new Loader();
		
		public function HelpView()
		{
			super();
			
			var bmp:Bitmap = new Bitmap();
			var bmd:BitmapData;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				var w:Number = stage.stageWidth-50;
				var h:Number = stage.stageHeight-50;
				bmd ||= new BitmapData(w,h,true);
				var m:Matrix = new Matrix();
				m.scale(w/loader.width,h/loader.height);
				bmd.draw(loader,m,null,null,null,true);
				bmp.bitmapData = bmd;
				
				bmp.x = 25;
				bmp.y = 25;
			});
			
			this.addChild(bmp);
		}
		
		public function set url(value:String):void
		{
			if(_url.url!=value)
			{
				loader.unloadAndStop();
				
				_url.url = value;
				
				loader.load(_url);
			}
		}
	}
}