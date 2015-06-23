package com.idzeir.bussies.manager
{
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.bussies.player.PlayerModule;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	public class DoneEncry extends Sprite
	{
		public function DoneEncry()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.autoSize = "left"
			txt.defaultTextFormat = new TextFormat(Utils.FONT_NAME,15,0xffffff,true);
			txt.text="2 秒后预览加密文件";
			txt.x = (stage.stageWidth - txt.width)>>1;
			txt.y = (stage.stageHeight - txt.height)>>1;
			this.addChild(txt);
			setTimeout(onReview,2000);
		}
		
		private function onReview():void
		{
			Utils.mediator.send(Enum.CHANGE_SCREEN,PlayerModule);
			this.parent.removeChild(this);
		}
	}
}