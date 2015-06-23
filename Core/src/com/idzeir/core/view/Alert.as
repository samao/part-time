package com.idzeir.core.view
{
	import com.idzeir.core.utils.Utils;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	final public class Alert extends Sprite
	{
		private var _title:Label;
		private var _bglayer:Shape;
		private var _line:Shape;
		
		private var _info:TextField;
		
		private var _close:Button;
		private var _closeFun:Function;
		
		public function Alert(msg:String,title:String = "信息")
		{
			super();
			
			initChildren();
			
			setWH();
			
			updateInfo(msg,title);
			
			addChildren();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function addChildren():void
		{
			this.addChild(_bglayer);
			this.addChild(_title);
			this.addChild(_line);
			this.addChild(_info);
			this.addChild(_close);
		}
		
		public function updateInfo(msg:String, title:String,closeFun:Function=null):void
		{
			_closeFun = closeFun;
			_title.htmlText = title;			
			_info.htmlText = msg;
			align();
		}
		
		protected function align():void
		{
			var gap:int = 5;
			_title.x = gap;
			_title.y = gap;
			
			_line.x = 1.5;
			_line.y = _title.x + _title.height + gap;

			_info.y = (((_bglayer.height - _line.y) - _info.height) >> 1) + _line.y;
			//_info.x = ((_bglayer.width - 20 - _info.width)>>1)+10;
			_info.x = 10;
			
			_close.x = _bglayer.width - _close.width - 2*gap;
			_close.y = gap;
		}
		
		public function setWH(w:int = 120, h:int = 80):void
		{
			_bglayer.graphics.clear();
			//_bglayer.graphics.lineStyle(1,0xffffff,.3);
			_bglayer.graphics.beginFill(0x000000,.6);
			_bglayer.graphics.drawRect(0,0,w,h);
			
			_title.maxWidth = w - 3;
			_info.width = w - 20;
			
			_line.graphics.clear();
			_line.graphics.beginFill(0xffffff,.3);
			_line.graphics.drawRect(0,0,w-2,1);
			_line.graphics.endFill();
			
			align();
		}
		
		protected function onAdded(event:Event):void
		{
			/*this.addChild(_bglayer);
			this.addChild(_title);
			this.addChild(_line);
			this.addChild(_info);*/
		}
		
		private function initChildren():void
		{
			_title = new Label();
			
			_bglayer = new Shape();
			//_bglayer.graphics.lineStyle(1,0xffffff,.3);
			_bglayer.graphics.beginFill(0x000000,.6);
			_bglayer.graphics.drawRect(0,0,120,80);
			
			_line = new Shape();
			_line.graphics.beginFill(0xffffff,.3);
			_line.graphics.drawRect(0,0,120,1);
			_line.graphics.endFill();
			
			_info = new TextField();
			_info.autoSize = TextFieldAutoSize.CENTER;
			_info.multiline = true;
			_info.wordWrap = true;
			_info.mouseEnabled = false;
			var tf:TextFormat = new TextFormat(Utils.FONT_NAME,12,0xffffff,false);
			tf.align = TextFormatAlign.CENTER;
			tf.leading = 5;
			_info.defaultTextFormat = tf;
			
			//_info.border = true;
			//_info.borderColor = 0xff0000;
			
			_close = new Button("<font color='#ffffff'>X</font>",function():void
			{
				_closeFun&&_closeFun.apply();
			});
			_close.bglayer = new Shape();
		}		
		
	}
}