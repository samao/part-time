package com.idzeir.bussies.player
{
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PwdChecker extends Sprite
	{

		private var inPut:TextField;
		public function PwdChecker()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			var tf:TextFormat = new TextFormat(Utils.FONT_NAME,null,0xffffff,true);
			var sTxt:TextField = new TextField();
			sTxt.defaultTextFormat = tf;
			sTxt.autoSize = "left";
			sTxt.text = "输入播放密码 :";
			sTxt.mouseEnabled = false;
			this.addChild(sTxt);
			
			inPut = new TextField();
			inPut.defaultTextFormat = tf;
			inPut.border = true;
			inPut.background = true;
			inPut.displayAsPassword = true;
			inPut.type = "input";
			inPut.maxChars = 16;
			inPut.backgroundColor = 0x000000;
			inPut.width = 150;
			inPut.height = 20;
			inPut.x = sTxt.width +10;
			this.addChild(inPut);
			
			var but:Button = new Button("播放",play);
			but.x = inPut.x +inPut.width+10;
			this.addChild(but);
		}
		
		private function play(e:MouseEvent):void
		{
			Utils.mediator.send(Enum.PWD_CHECK,inPut.text);
			this.parent.removeChild(this);
		}
	}
}