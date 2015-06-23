package com.idzeir.core.view 
{
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	internal class DebugerUI extends VScrollPanel implements ILoger
	{
		private var logTxt:TextField;
		
		public function DebugerUI() 
		{
			super();
			var tf:TextFormat = new TextFormat("宋体,微软雅黑", 12, null, false);
			tf.leading = 3;
			logTxt = new TextField();
			logTxt.defaultTextFormat = tf;
			logTxt.autoSize = "left";
			logTxt.textColor = 0xffffff;
			logTxt.multiline = true;
			logTxt.wordWrap = true;
			logTxt.selectable = false;
			this.addChild(logTxt);
		}
		
		public function viewPort(w:Number, h:Number):void 
		{			
			super.setSize(w,h);
			this.graphics.clear();
			this.graphics.beginFill(0x000000,.3);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
			if (logTxt)
			{
				logTxt.width = w;
			}
		}
		
		public function log(...arg:*):void
		{
			var date:Date = new Date();
			var time:String = date.toLocaleTimeString().replace(/((\d{2}\:){2}\d{2}) ([A,P]M)/ig,"$3 $1");
			var str:String = "#"+time+"# " + arg.join(" ");
			//trace(str);
			this.appendText(str);
			this.resize();
			this._vScrollbar.value = this._vScrollbar.maximum;
		}
		
		public function unTimeLog(...arg:*):void
		{
			var str:String = arg.join(" ");
			//trace(str);
			this.appendText(str);
			this.resize();
			this._vScrollbar.value = this._vScrollbar.maximum;
		}
		
		public function appendText(arg:String):void
		{
			logTxt.htmlText+=arg
		}
	}

}