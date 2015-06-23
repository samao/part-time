package com.idzeir.core.view 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class Panel extends Sprite 
	{		
		protected var _width:Number = 100;
		protected var _height:Number = 100;
		private var bglayer:Shape;
		
		protected var content:Sprite;
		
		private var _mask:Shape;
		
		public function Panel() 
		{
			bglayer = new Shape();
			bglayer.graphics.beginFill(0x000000, .6);
			bglayer.graphics.drawRect(0, 0, 10, 10);
			bglayer.graphics.endFill();
			super.addChild(bglayer);
			
			content = new Sprite();			
			super.addChild(content);
			
			_mask = new Shape();
			_mask.graphics.beginFill(0x000000, .2);
			_mask.graphics.drawRect(0, 0, 10, 10);
			_mask.graphics.endFill();
			super.addChild(_mask);
			
			content.mask = _mask;			
			viewPort(100, 100);
		}
		
		public function backgroundColor(value:int,alpha:Number=1):void
		{
			bglayer.graphics.clear();
			bglayer.graphics.beginFill(value, alpha);
			bglayer.graphics.drawRect(0, 0, 10, 10);
			bglayer.graphics.endFill();
			this.invaild();
		}
		
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		public function addRawChildAt(child:DisplayObject,index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return content.addChild(child);
		}
		
		/**
		 * 显示窗口大小
		 * @param	w
		 * @param	h
		 */
		public function viewPort(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			invaild();
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			invaild();
		}
		
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			invaild();
		}
		
		override public function get height():Number 
		{
			return _height;
		}
		
		protected function invaild():void
		{
			bglayer.width = _width;
			bglayer.height = _height;
			_mask.width = _width;
			_mask.height = _height;
		}
	}

}