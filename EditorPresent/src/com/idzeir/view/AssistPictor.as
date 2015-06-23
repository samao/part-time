package com.idzeir.view 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class AssistPictor extends Sprite 
	{
		static private var _instance:AssistPictor;
		
		private var loader:Loader;
		
		public function AssistPictor() 
		{
			super();
			this.mouseEnabled = false;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			//this.addChild(loader);
		}
		
		static public function getAssist():AssistPictor
		{
			if (!_instance)
			{
				_instance = new AssistPictor();
			}
			return _instance;
		}
		
		private function onComplete(e:Event):void
		{
			this.removeChildren();
			var bitmap:Bitmap = e.target.content as Bitmap;
			this.addChild(bitmap);
			this.x = (stage.stageWidth - this.width) >> 1;
			this.y = (stage.stageHeight -this.height) >> 1;
		}
		
		public function set content(value:String):void 
		{
			loader.load(new URLRequest(value));
		}
	}

}