package com.idzeir.livepush.module
{	
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Logger;
	import com.idzeir.livepush.enum.Enum;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 3, 2014 12:32:44 PM
	 *
	 **/
	
	public class BGLayerModule extends Module
	{
		private var _loader:Loader;
		private var _url:URLRequest;
		
		public function BGLayerModule()
		{
			super();
			_loader = new Loader();
			_url = new URLRequest();
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onReady);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			
			_e.watch(Enum.BG_CHANGE,function(value:String):void
			{
				url = value;
			});
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			
		}
		
		protected function errorHandler(event:IOErrorEvent):void
		{
			Logger.out(this,"加载背景图片失败");
		}
		
		protected function onReady(event:Event):void
		{
			Logger.out(this,"背景图片加载完成");
			this.removeChildren();
			
			var bg:DisplayObject = event.target.content as DisplayObject;
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			this.addChild(bg);
			
			Utils.tween.fromTo(this,1,{alpha:0},{alpha:1});
		}
		
		public function set url(value:String):void
		{
			_loader.unloadAndStop();
			_url.url = value;
			var ldr:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			ldr.allowCodeImport = false;
			ldr.checkPolicyFile =false;
			ldr.allowLoadBytesCodeExecution = false;
			_loader.load(_url);
		}
	}
}