package com.idzeir.bussies.manager
{
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AuthorCode extends Sprite
	{

		private var txt:TextField;
		
		public function AuthorCode()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			var tf:TextFormat = new TextFormat(Utils.FONT_NAME,null,0xffffff,true);
			var stxt:TextField = new TextField();
			stxt.mouseEnabled = false;
			stxt.defaultTextFormat = tf;
			stxt.autoSize = "left";
			stxt.text = "设置授权码:";
			this.addChild(stxt);
			
			txt = new TextField();
			txt.defaultTextFormat = tf;
			txt.border = true;
			txt.background = true;
			txt.type = "input";
			txt.maxChars = 16;
			txt.backgroundColor = 0x000000;
			txt.width = 150;
			txt.height = 20;
			txt.x = stxt.width +10;
			this.addChild(txt);
			
			var save:Button = new Button("保存",onSave);
			save.x = txt.x+txt.width + 10;
			this.addChild(save);
		}
		
		private function onSave(e:MouseEvent):void
		{
			Utils.mediator.send(Enum.SAVE_FILE,txt.text);
		}
	}
}