package com.idzier.view 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="change",type="flash.events.Event")]
	/**
	 * ...
	 * @author idzeir
	 */
	public class Slider extends Sprite 
	{
		private var _back:Shape;
		
		private var _handle:Sprite;
		
		private var offsetY:Number = 0;
		
		private var _value:Number = 0;
		
		public function Slider() 
		{
			this.addChildren();
		}
		
		public function set value(num:Number):void
		{
			_value = num;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():Number
		{
			return Number(_value.toFixed(2));
		}
		
		public function setSize(w:Number, h:Number):void 
		{
			_back.width = w;
			_back.height = h;
			_handle.width = w - 4;
			_handle.x = 2;
		}
		
		protected function addChildren():void
		{
			_back = new Shape();
			_back.graphics.beginFill(0xff0000, .6);
			_back.graphics.drawRect(0, 0, 10, 100);
			_back.graphics.endFill();
			
			_handle = new Sprite();
			_handle.graphics.beginFill(0x000000);
			_handle.graphics.drawRect(0, 0, 6, 20);
			_handle.graphics.endFill();
			
			_handle.x = 1;
			this.addChild(_back);
			this.addChild(_handle);
			
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
		}
		
		private function onPress(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			addEventListener(Event.ENTER_FRAME, onMove);
			offsetY = e.localY;
		}
		
		private function onMove(e:Event):void 
		{
			var oldValue:Number = _value;
			
			if (mouseY <= 0)
			{
				_handle.y = 0;
			}else if (mouseY >= (_back.height - _handle.height)){
				_handle.y = (_back.height - _handle.height);
			}else {
				_handle.y = mouseY - offsetY;
			}		
			
			_value = Math.max(0, _handle.y / (_back.height - _handle.height));
			
			if (oldValue != value)
			{	
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function onDrop(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			removeEventListener(Event.ENTER_FRAME, onMove);
		}
	}

}