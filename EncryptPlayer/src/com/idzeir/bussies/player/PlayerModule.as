package com.idzeir.bussies.player
{
	
	import com.hurlant.util.Base64;
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class PlayerModule extends Sprite
	{

		private var file:URLStream;
		
		private var loader:Loader;

		private var code:String;

		private var data:ByteArray;

		private var pwdChecker:PwdChecker;
		
		private var _content:Sprite;

		private var isMedia:Boolean;
		
		public function PlayerModule()
		{
			super();
			_content = new Sprite();
			this.addChild(_content);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onReady);
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onReady(event:Event):void
		{
			
		}
		
		protected function onAdded(event:Event):void
		{
			play();
		}
		
		private function play():void
		{
			file = new URLStream();
			file.addEventListener(Event.COMPLETE,onComplete);
			file.addEventListener(IOErrorEvent.IO_ERROR,onError);
			file.load(new URLRequest(Enum.SAVE_FILE_NAME));
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			file.removeEventListener(Event.COMPLETE,onComplete);
			file.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			this.parent.removeChild(this);
			Utils.mediator.send("error","未找到数据源文件data.res.");
		}
		
		protected function onComplete(event:Event):void
		{
			file.removeEventListener(Event.COMPLETE,onComplete);
			file.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			
			var len:int = file.readShort();			
			code = file.readMultiByte(len,"gb2312");			
			isMedia = file.readBoolean();			
			data = new ByteArray();
			file.readBytes(data);			
			if(len == 0)
			{
				playBytes()
				return;
			}
			trace("授权密码：",Base64.decode(code));
			addChecker();
			Utils.mediator.watch(Enum.PWD_CHECK,onCheck);
		}
		
		private function addChecker():void
		{
			pwdChecker = new PwdChecker();
			this.addChild(pwdChecker);
			pwdChecker.x = (stage.stageWidth - pwdChecker.width)>>1;
			pwdChecker.y = (stage.stageHeight -pwdChecker.height)>>1;
		}
		
		private function onCheck(pwd:String=null):void
		{
			if(pwd==Base64.decode(this.code))
			{
				Utils.mediator.remove(Enum.PWD_CHECK,onCheck);
				playBytes();
				return;
			}
			setTimeout(this.addChecker,1000);
		}
		
		private function playBytes():void
		{
			if(isMedia)
			{
				Utils.mediator.send(Enum.ERROR,"不支持的文件格式");
				var media:MediaPlayer = new MediaPlayer();	
				this._content.addChild(media);
				media.play(data);	
				if(!Utils.windowOS)Utils.mediator.send(Enum.TO_SCALE,this._content);
				return;
			}
			var ldr:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			ldr.allowCodeImport = true;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onByteReady);
			loader.loadBytes(data,ldr);
		}
		
		protected function onByteReady(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onByteReady);
			if(!Utils.windowOS)Utils.mediator.send(Enum.TO_SCALE,this._content);
			this._content.addChild(loader);
		}
	}
}