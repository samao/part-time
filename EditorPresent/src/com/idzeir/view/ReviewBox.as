package com.idzeir.view 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class ReviewBox extends Sprite 
	{
		private var animationCount:uint = 0;
		
		public function ReviewBox() 
		{
			super();
			
		}
		
		public function hiden():void 
		{
			this.visible = false;
			this.removeChildren();
			animationCount = 0;
			TweenMax.killAll();
		}
		
		public function viewAnimation(posMap:Vector.<Point>, bitmap:Bitmap):void 
		{
			animationCount = posMap.length;
			this.visible = true;
			var bmp:BitmapData = bitmap.bitmapData.clone();		
			for (var i:uint = 0; i < posMap.length; i++)
			{
				var bitmap:Bitmap = new Bitmap(bmp);				
				bitmap.width = bitmap.height = 20;
				
				var rect:Rectangle = bitmap.getBounds(this);
				rect.inflate(100, 100);
				
				bitmap.x = posMap[i].x+rect.left+Math.random()*rect.width;;
				bitmap.y = posMap[i].y+rect.top+Math.random()*rect.height;;
				this.addChild(bitmap);
				
				TweenMax.to(bitmap, 2, {"x":posMap[i].x,"y":posMap[i].y,onComplete:onComplete } );
			}
		}
		
		private function onComplete():void 
		{
			if (--animationCount <= 0)
			{
				hiden();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}

}