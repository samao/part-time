package com.idzier.bussies 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class MessView extends Sprite 
	{
		private var loader:Loader;
		private var _data:Object;
		
		private var _txt:TextField;
		private var tf:TextFormat;
		
		public function MessView() 
		{
			super();
			_txt = new TextField();
			_txt.autoSize = "left";
			tf = new TextFormat("宋体,微软雅黑", 12, 0, true);
			tf.leading = 17;
			_txt.defaultTextFormat = tf;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onReady);	
			this.mouseChildren = false;
			_txt.filters = [new BlurFilter(1,1,1),new GlowFilter(0xffffff,1,2,2,3,1)]
		}
		
		public function set content(value:Object):void
		{
			visible = false;
			_data = value;
			loader.load(new URLRequest(value.url));
		}
		
		private function onReady(e:Event):void 
		{			
			this.visible = true;
			var tar:Bitmap = e.target.content as Bitmap;
			
			this.addChild(tar);
			
			this.addChild(_txt);

			_txt.htmlText = "<font color='#0000ff'>"+_data.sender + "</font>\n      送给   <font color='#0000ff'>" + _data.reciver + "</font>\n" + "\t\t\t<font color='#ff0000'>"+_data.giftName+"</font>"
			_txt.x = 80;
			_txt.y = 35;
			
		}
		
	}

}