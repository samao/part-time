package com.idzier.view 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * ...
	 * @author idzeir
	 */
	public class VScrollPanel extends Panel 
	{
		private var slider:Slider;
		
		public function VScrollPanel() 
		{
			super();
			addChildren();
		}
		
		protected function addChildren():void
		{
			slider = new Slider();
			slider.addEventListener(Event.CHANGE, chanage);
			slider.x = this._width - slider.width;
			addRawChild(slider);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			super.addChild(child);			
			return child;
		}
		
		private function chanage(e:Event):void 
		{
			//trace("chanage", slider.value);
			if (_height < this.content.height)
			{
				content.y = -slider.value * (content.height - _height);
			}
		}
		
		override protected function invaild():void 
		{
			super.invaild();
			if (slider)
			{
				slider.x = this._width - slider.width;				
				slider.setSize(10, _height);
				slider.visible = (_height < this.content.height);
			}
		}
	}

}