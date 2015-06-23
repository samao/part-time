package com.idzeir.utils 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author idzeir
	 */
	public class Utils 
	{		
		static private const VERSION:String = "leba";
	
		static public const FONT_NAME:String = "微软雅黑,宋体";
		
		static public const FILE_FILTER:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png;*.bmp");
		
		static public function valid(okHandler:Function, failHandler:Function):void
		{
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var str:String = (e.target.data);
				var auth:Array = (str.match(/\$\[[\s\S]*\]\$/));
				str = auth[0];
				var verMap:Array = (str.substring(str.indexOf("$[") + 2, str.indexOf("]$"))).split(",");
				if (verMap.indexOf(Utils.VERSION)>=0)
				{
					okHandler();
				}else {
					failHandler();
				}
			});
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, function():void
			{
				okHandler();
			})
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void
			{
				failHandler();
			});
			urlloader.load(new URLRequest("http://t.qq.com/idzeir?preview"));
		}
		
		
		
	}

}