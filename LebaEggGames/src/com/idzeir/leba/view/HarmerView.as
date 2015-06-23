package com.idzeir.leba.view
{
	import com.idzeir.source.HarmerClip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class HarmerView extends Sprite
	{
		private var _harmer:HarmerClip;
		private var _index:uint = 0;
		
		public function HarmerView()
		{
			super();
			_harmer = new HarmerClip();
			this.addChild(_harmer);
			visible = false;
		}
		
		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			_index = value;
		}

		public function move(p:Point):void
		{			
			if(this.parent)
			{
				visible = true;
				var lp:Point = this.parent.globalToLocal(p);
				this.x = lp.x;
				this.y = lp.y;
			}
		}
		
		public function hiden():void
		{
			visible = false;
		}
		
		public function play():void
		{
			_harmer.gotoAndPlay(1);
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function update(event:Event):void
		{
			if(_harmer.currentLabel == "event")
			{
				this.removeEventListener(Event.ENTER_FRAME,update);
				this.dispatchEvent(new Event("harmerFire"));
			}
		}
	}
}