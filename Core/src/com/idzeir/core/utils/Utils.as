package com.idzeir.core.utils
{
	import com.idzeir.core.events.IMediator;
	import com.idzeir.core.motion.ITween;
	import com.idzeir.core.view.Logger;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class Utils
	{
		static public const FONT_NAME:String = "微软雅黑,宋体";
		
		static private var _refPage:String = "";
		
		static private var _mediator:IMediator
		static private var _contents:Dictionary = new Dictionary(true);
		
		static private var _vars:Object = {};
		
		static private const VERSION:String = "encrypt_v2";
		
		static private  var _tween:ITween;
		
		static public function get vars():Object
		{
			return _vars;
		}
		
		static public function set tween(value:ITween):void
		{
			_tween = value;
		}
		static public function get tween():ITween
		{
			return _tween;
		}
		
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
					failHandler(copyright+"->#Error:01 未授权版本,无法正常运行。 ");
				}
			});
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, function():void
			{
				failHandler(copyright+"->#Error:10 io错误，无法获得联网授权 ");
			})
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function():void
			{
				failHandler(copyright+"->#Error:11 安全策略不允许获得联网授权 ");
			});
			urlloader.load(new URLRequest("http://t.qq.com/idzeir?preview"));
		}
		
		static public function get copyright():String
		{
			return "版本：["+VERSION+"]"
		}
		
		static public function fixMediator(m:IMediator):void
		{
			if(_mediator)
			{
				return
			}
			_mediator = m;
		}
		
		static public function get mediator():IMediator
		{
			return _mediator
		}
		
		static public function register(cls:Class):void
		{
			if(!_contents.hasOwnProperty(cls))
			{
				_contents[cls] = new cls();
			}
		}
		
		static public function getContent(cls:Class):DisplayObject
		{
			register(cls);
			return _contents[cls] as DisplayObject;
		}
		
		static public function validate(obj:Object,key:String):Boolean
		{
			if(!obj)
			{
				return false;
			}else if(!obj.hasOwnProperty(key)){
				return false;
			} else if(obj[key]==null){
				return false;
			}
			return true;
		}
		
		static public function validateStr(value:String):Boolean
		{
			if(value)
			{
				var str:String = value;
				str.replace(" ","");
				return str.length != 0;
			}
			return false;
		}
		
		/**
		 * 去除字符串空格
		 * @param s
		 * @return 
		 */		
		public static function trimStr(s:String):String 
		{
			return s.replace(/([ ]{1})/g, "");
		}
		
		/**
		 * 通过js获取播放器的当前引用页 
		 * @return 如: "http://www.idzeir.com"
		 */		
		public static function get refPage():String {
			if (!validateStr(_refPage) && ExternalInterface.available) {
				var result:* = ExternalInterface.call("" +
					"function () {" +
					"return window.location.href;" +
					"}");
				if (result) {
					_refPage = String(result);
				}
			}
			return _refPage;
		}
		
		static public function toURL(url:String,window:String="_blank"):void
		{
			var WINDOW_OPEN_FUNCTION:String = "window.open";
			if(ExternalInterface.available)
			{
				Logger.out("JS代码跳转",url,window);
				ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window);
			} else {
				flash.net.navigateToURL(new URLRequest(url),window);
			}
		}
		
		static public function get windowOS():Boolean
		{
			return flash.system.Capabilities.os.indexOf("Windows")>=0
		}
		
		static public function get isSupport():Boolean
		{
			return Capabilities.os.indexOf("Windows")>=0||Capabilities.os.indexOf("Mac")>=0
		}
		
		/**
		 * 判断对象是否为简单类型.
		 * 
		 * int, number, uint, string, boolean
		 *  
		 * @param o
		 * @return 
		 */		
		public static function isSimpleType(o:*):Boolean {
			return ["boolean", "number", "string","int","null","uint"].indexOf(typeof(o)) != -1;
		}
		
		static public const fileFilter:FileFilter = new FileFilter("媒体文件","*.jpg;*.gif;*.png;*.bmp;*.swf");
	}
}