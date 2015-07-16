package com.idzeir.service
{
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.events.InfoEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * http接口服务
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	final public class HttpService extends EventDispatcher implements IHttp
	{
		private var loader:URLLoader
		private var url:URLRequest;

		private var queue:Vector.<PostMatcher>
		/**
		 * 队列执行标记 
		 */		
		private var _running:Boolean = false;

		public function HttpService(target:IEventDispatcher = null)
		{
			super(target);
			queue = new Vector.<PostMatcher>();

			loader = new URLLoader();
			url = new URLRequest();
			url.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}

		protected function onError(event:Event):void
		{
			queue.shift().failure(event.type);
			G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:event.type}));
			load();
		}

		protected function onComplete(event:Event):void
		{
			queue.shift().handle(JSON.parse(event.target.data));
			load();
		}

		public function post(url:String, params:Object = null, ok:Function = null, fail:Function = null):void
		{
			queue.push(new PostMatcher(url, params, ok, fail));
			!_running && load();
		}

		private function load():void
		{
			if (queue.length > 0)
			{
				_running = true;
				var matcher:PostMatcher = queue[0];
				url.url = matcher.url;
				url.data = matcher.params;
				loader.load(url);
			}
			else
			{
				_running = false;
			}
		}
	}
}

class PostMatcher
{
	public var url:String;
	public var params:Object;
	public var ok:Function;
	public var fail:Function;

	public function PostMatcher(url:String, params:Object, ok:Function, fail:Function)
	{
		this.url = url;
		if (this.params)
		{
			this.params.t = new Date().time;
		}
		else
		{
			if (this.url.indexOf("?") != -1)
			{
				this.url += "&t=" + new Date().time;
			}
			else
			{
				this.url += "?t=" + new Date().time;
			}
		}

		this.params = params;
		this.ok = ok;
		this.fail = fail;
	}

	public function handle(value:* = null):void
	{
		if (ok)
		{
			ok.apply(null, [value]);
		}
	}

	public function failure(value:* = null):void
	{
		if (fail)
		{
			fail.apply(null, ["地址: " + url + " 原因:" + value]);
		}
	}
}