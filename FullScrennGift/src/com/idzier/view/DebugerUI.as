package com.idzier.view 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class DebugerUI extends VScrollPanel 
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
		
		override public function viewPort(w:Number, h:Number):void 
		{			
			super.viewPort(w, h);
			if (logTxt)
			{
				logTxt.width = w;
			}
		}
		
		public function appendText(arg:String):void
		{
			logTxt.htmlText+=arg
			this.invaild();
		}
	}

}