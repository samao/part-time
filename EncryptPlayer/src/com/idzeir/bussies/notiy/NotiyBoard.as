package com.idzeir.bussies.notiy
{
	import com.idzeir.core.utils.Utils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class NotiyBoard extends Sprite implements INotiy
	{
		private var _msg:TextField;
		
		public function NotiyBoard()
		{
			super();
			this.mouseEnabled = false;
			
			_msg = new TextField();
			_msg.mouseEnabled = false;
			_msg.autoSize = "left";
			_msg.defaultTextFormat = new TextFormat(Utils.FONT_NAME,18,0xff0000,true);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			this.addChild(_msg);
			this.align();
		}
		
		public function set text(value:String):void
		{
			_msg.text = value;
			this.align();
		}
		
		private function align():void
		{
			_msg.x = (stage.stageWidth - _msg.width)>>1;
			_msg.y = (stage.stageHeight - _msg.height)>>1;
		}
	}
}