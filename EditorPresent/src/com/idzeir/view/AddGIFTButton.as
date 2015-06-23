package com.idzeir.view 
{
	import com.idzeir.utils.Utils;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class AddGIFTButton extends Sprite 
	{
		private var txt:TextField;
		
		private var _icon:Bitmap;
		
		public function AddGIFTButton() 
		{
			super();
			
			mouseChildren = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			txt = new TextField();
			txt.autoSize = "left";
			txt.defaultTextFormat = new TextFormat(Utils.FONT_NAME, 12, 0xffffff, true);
			txt.text = "+(礼物)";
			this.addChild(txt);
			this.graphics.beginFill(0xffffff, 0);
			this.graphics.drawRect(0, 0, 35, 35);
			this.graphics.endFill();
			txt.x = (this.width - txt.width) >> 1;
			txt.y = (this.height - txt.height) >> 1;
		}
		
		public function setICON(value:Bitmap):void
		{			
			value.width = 30;
			value.height = 30;
			value.y = (this.height - 30) >> 1;
			value.x = (this.width -30) >> 1;
			this.removeChild(txt);
			this.addChild(value);
			//this.mouseEnabled = false;
			_icon = value;
		}
		
		public function get icon():Bitmap
		{
			return _icon;s
		}
	}

}