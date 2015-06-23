package com.idzeir.leba.view
{
	import com.idzeir.source.GoldEggClip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class EggView extends Sprite
	{
		private var _index:uint = 0;
		private var _eg:GoldEggClip;
		
		public function EggView(value:uint)
		{
			super();
			_index = value;
			this.buttonMode = true;
			this.mouseChildren = false;
			_eg = new GoldEggClip();
			this.addChild(_eg);			
		}
		
		public function play():void
		{
			_eg.gotoAndPlay(1);
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function update(event:Event):void
		{
			if(_eg.currentLabel == "event")
			{
				this.removeEventListener(Event.ENTER_FRAME,update);
				this.dispatchEvent(new Event("showFeedBack"));
			}
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function get stageTop():Point
		{
			return this.localToGlobal(new Point(this.width*.5,0));
		}
	}
}