package com.idzeir.flashviewer.module.fileGrid
{	
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 28, 2014 3:36:07 PM
	 *
	 **/
	
	public class ViewPicture extends Module
	{
		private var _loader:Loader;
		private var _url:URLRequest;
		private var _content:Sprite;
		
		private const PADDING:uint = 4;

		private var curURL:String;
		
		public function ViewPicture()
		{
			super();
			this.buttonMode = true;
			graphics.beginFill(0xffffff);
			graphics.lineStyle(2,0xb3b3b3);
			graphics.drawRect(1,1,FileCard.CARD_WIDTH - 2,110 - 2);
			graphics.endFill();			
			_loader = new Loader();
			_url = new URLRequest();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void
			{
				Logger.out("ViewPicture","预览图加载失败：",_url.url);
			});
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			
			_content = new Sprite();
			this.addChild(_content);
			this._e.watch(Enum.CREATE_PHOTO_COMPLETE,reflush);
		}
		
		private function reflush(url:String):void
		{
			if(curURL==url)
			{
				this.url = url;
			}			
		}
		
		/**
		 * 是否选中了预览图 
		 * @param bool
		 * 
		 */		
		public function set selected(bool:Boolean):void
		{
			if(bool)
			{
				this.filters = [new GlowFilter(0x000000,1,3,3,3,1,true)]
			}else{
				this.filters = [];
			}
		}
		
		protected function onComplete(event:Event):void
		{
			_content.addChild(event.target.content as DisplayObject);	
			_content.width = FileCard.CARD_WIDTH-PADDING*2;
			_content.height = 110-PADDING*2;
			_content.x = _content.y = PADDING;
		}
		
		public function set url(value:String):void
		{
			curURL = value;
			var file:File = new File(value);
			if(file.exists)
			{
				file.addEventListener(Event.COMPLETE,function():void
				{
					_loader.unloadAndStop();
					_content.removeChildren();
					_url.url = value;
					_loader.loadBytes(file.data);
				});
				file.load();
			}
		}
	}
}