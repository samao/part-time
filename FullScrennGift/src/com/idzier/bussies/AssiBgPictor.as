package com.idzier.bussies 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class AssiBgPictor extends Sprite 
	{
		static private var _instance:AssiBgPictor;
		private var queue:LoaderMax;
		
		public function AssiBgPictor() 
		{
			super();			
			queue = new LoaderMax({name:"subQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
		}
		
		static public function getAssisPictor():AssiBgPictor
		{
			if (!_instance)
			{
				_instance = new AssiBgPictor();
			}
			return _instance;
		}
		
		public function set background(value:String):void
		{
			this.removeChildren();
			queue.append(new ImageLoader(value, { name:"bgImage" } ));
			queue.load();
		}
		
		private function completeHandler(e:LoaderEvent):void 
		{
			var bg:DisplayObject = queue.getContent("bgImage") as DisplayObject;
			if (bg) this.addChildAt(bg, 0);
		}
		
		private function errorHandler(e:LoaderEvent):void 
		{
			
		}
		
		private function progressHandler(e:LoaderEvent):void 
		{
			
		}
	}

}