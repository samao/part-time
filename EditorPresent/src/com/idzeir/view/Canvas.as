package com.idzeir.view 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class Canvas extends Sprite implements ICanvas 
	{
		private var virBox:Sprite;
		
		private var reViewBox:ReviewBox;
		
		public function Canvas() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);			
			
			virBox = new Sprite();
			this.addChild(virBox);
			var firstVir:VirGiftShape = new VirGiftShape();
			firstVir.x = (stage.stageWidth - firstVir.width) >> 1;
			firstVir.y = (stage.stageHeight - firstVir.height) >> 1;
			virBox.addChild(firstVir);
			
			reViewBox = new ReviewBox();
			reViewBox.addEventListener(Event.COMPLETE, function():void
			{
				virBox.visible = true;
			});
			reViewBox.hiden();
			this.addChild(reViewBox);
		}
		
		public function set gift(bitmap:Bitmap):void
		{			
			virBox.visible = false;
			
			reViewBox.viewAnimation(map, bitmap);
		}
		
		public function get map():Vector.<Point>
		{
			var posMap:Vector.<Point> = new Vector.<Point>();
			
			for (var i:uint; i < virBox.numChildren; i++)
			{
				var tar:DisplayObject = virBox.getChildAt(i);				
				posMap.push(new Point(tar.x, tar.y));
			}
			return posMap;
		}
		
		public function addItem(value:DisplayObject):void
		{
			virBox.addChild(value);
		}
		
		public function select(value:DisplayObject):void
		{
			if (virBox.getChildIndex(value) != (virBox.numChildren -1))
			{
				virBox.setChildIndex(value, virBox.numChildren - 1);				
			}				
		}
	}

}