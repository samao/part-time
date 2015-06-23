package com.idzeir.leba.view
{
	import com.greensock.TweenMax;
	import com.idzeir.source.StarCheer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class LuckResultView extends Sprite
	{
		private var loader:Loader = new Loader();
		private var _url:URLRequest = new URLRequest();
		
		private var _item:Sprite = new Sprite();
		private var _star:StarCheer = new StarCheer();
		
		public function LuckResultView()
		{
			super();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLuckyReady);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			
			this.addChild(_item);
			_star.visible = false;
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			this.dispatchEvent(new Event("IOError"));
		}
		
		protected function onLuckyReady(event:Event):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000,.5);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.graphics.endFill();
			var bit:Bitmap = event.target.content as Bitmap;
			_item.removeChildren();
			bit&&_item.addChild(bit);
			
			_item.x = stage.stageWidth - _item.width>>1;
			_item.y = (stage.stageHeight - _item.height>>1) - 20;
			
			TweenMax.killTweensOf(_item);
			TweenMax.fromTo(_item,1,{alpha:0},{alpha:1,onComplete:onComplete});
			
			_star.gotoAndPlay(1);
			this.addChild(_star);
			_star.x = stage.stageWidth - _star.width>>1;
			_star.visible = true;
		}		
		
		private function onComplete():void
		{
			setTimeout(function():void
			{
				graphics.clear();
				_star.visible = false;
				_item.removeChildren();
				dispatchEvent(new Event("resetGame"));
			},2000);
		}
		
		public function set url(value:String):void
		{
			_url.url = value;
			loader.load(_url);
		}
	}
}