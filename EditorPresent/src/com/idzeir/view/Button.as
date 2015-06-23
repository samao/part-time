package com.idzeir.view 
{
	import com.idzeir.utils.Utils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class Button extends Sprite 
	{
		private var _label:String;
		private var txt:TextField;
		
		public function Button(label:String,handler:Function=null) 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			_label = label
			if (handler!=null)
			{
				this.addEventListener(MouseEvent.CLICK, handler);
			}
			
			createChildren();
		}
		
		private function createChildren():void 
		{
			txt = new TextField();
			txt.defaultTextFormat = new TextFormat(Utils.FONT_NAME);
			txt.autoSize = "left";
			this.addChild(txt);
			label = _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			txt.text = value;
			txt.x = 2;
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRoundRect(0, 0, this.width+4, this.height, 5, 5);
			this.graphics.endFill();
		}
	}

}