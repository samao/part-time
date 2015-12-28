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
			var w:Number = 800;
			var h:Number = 450;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				
				bmd ||= new BitmapData(loader.width,loader.height,true);
				var m:Matrix = new Matrix();
				m.scale(loader.width/w,loader.height/h);
				bmd.draw(loader,null,null,null,null,true);
				bmp.bitmapData = bmd;
				
				bmp.width = w;
				bmp.height = h;
				bmp.x = stage.stageWidth - w>>1;
				bmp.y = stage.stageHeight - h>>1;
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