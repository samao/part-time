package
{	
	import com.idzeir.core.view.BaseStage;
	import com.idzeir.core.view.Logger;
	import com.idzeir.livepush.enum.Enum;
	import com.idzeir.livepush.module.BGLayerModule;
	import com.idzeir.livepush.module.Screen;
	import com.idzeir.livepush.video.VideoAudioVars;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.scanHardware;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jan 14, 2011 6:21:49 PM
	 *
	 **/
	[SWF(backgroundColor="#343434" width="480" height="360")]
	public class LivePushPlayer extends BaseStage implements ILivePushPlayer
	{
		private var _box:Sprite;
		private var _screen:Screen;
		
		public function LivePushPlayer()
		{
			flash.media.scanHardware();
		}
		
		override protected function init(event:Event=null):void
		{
			super.init(event);
			this.preInit();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.userTicker = true;
			
			Logger.out(this,"舞台初始化完成");
			
			_box = new Sprite();
			this.addChild(_box);
			
			_box.addChild(new BGLayerModule());
			
			_screen = new Screen();
			_box.addChild(_screen);
			
			var hardwares:Object = {};
			if(Camera.isSupported)
			{
				hardwares.camera = Camera.names;
			}
			if(Microphone.isSupported){
				hardwares.microphone = Microphone.names;
			}
			
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("publish",publish);
				ExternalInterface.addCallback("playStream",playStream);
				ExternalInterface.addCallback("setType",setType);
				ExternalInterface.addCallback("setRtmp",setRtmp);
				ExternalInterface.addCallback("streamName",streamName);
				ExternalInterface.addCallback("setBackgroundImg",setBackground);
				ExternalInterface.addCallback("playLive",playLive);
				ExternalInterface.addCallback("stopStream",stopStream);
				ExternalInterface.addCallback("setVolume",setVolume);
				ExternalInterface.call("playerReady",hardwares);
				Logger.out(this,"接口初始化完毕");
				
			}else{
				setType("push");
				this.setRtmp("rtmp://182.254.148.60/live/abc");
				this.streamName("livevid");
				this.playLive();
			}
			//1.设置播放器模式，拉流或者推流，背景
			//2.设置服务器地址
			//3.设置流名字
			//4.播放
			
			this.setDebugPort(stage.stageWidth,stage.stageHeight);
			_e.watch(Enum.CONNECTION_CLOSE,onClose);
		}
		
		public function stopStream():void
		{
			Logger.out(this,"js调用停止stop");
			_e.send(Enum.STOP);
		}
		
		public function publish(_rtmp:String,id:String,cam:String = null, mic:String = null):void
		{
			Logger.out(this,"publish接口调用",_rtmp,id,cam,mic);
			if(!cam&&!mic)
			{
				Logger.out(this,"未设置摄像头和音频无法直播");
				return;
			}
			
			setType("push");
			
			if(cam)
			{
				_e.send(Enum.CAMERA,cam);
			}
			if(mic)
			{
				_e.send(Enum.MICROPHONE,mic);
			}
			
			setRtmp(_rtmp);
			streamName(id);
			playLive();
		}	
		
		public function playStream(_rtmp:String,id:String):void
		{
			Logger.out(this,"playStream接口调用",_rtmp,id);
			setType("live");
			setRtmp(_rtmp);
			streamName(id);
			playLive();
		}
		
		private function preInit():void
		{
			VideoAudioVars.getParams().updateFromData(stage.loaderInfo.parameters);
		}
		
		private function onClose(value:*=null):void
		{
			Logger.out(this,"流断开onRtmpBreak");
			if(ExternalInterface.available)
			{
				ExternalInterface.call("onRtmpBreak",value);
			}
		}
		
		override protected function createMenu():void
		{
			if(stage.loaderInfo.parameters.hasOwnProperty("debug"))
			{
				_debug = Boolean(Number(stage.loaderInfo.parameters["debug"]));
			}
			super.createMenu();
		}
		
		public function playLive():void
		{
			Logger.out(this,"playLive接口调用");
			_e.send(Enum.PLAY);
		}
		
		public function setBackground(value:String):void
		{
			Logger.out(this,"setBg接口调用",value);
			_e.send(Enum.BG_CHANGE,value);
		}
		
		public function streamName(value:String):void
		{
			Logger.out(this,"streamName接口调用",value);
			_e.send(Enum.STREAM_CHANGE,value);
		}
		
		public function setRtmp(url:String):void
		{
			Logger.out(this,"setRtmp接口调用",url);
			_e.send(Enum.SERVER_CHANGE,url);	
		}
		
		public function setType(value:String):void
		{
			Logger.out(this,"setType接口调用",value);
			_screen.switchView(value);
		}
		
		public function setVolume(value:Number):void
		{
			Logger.out(this,"setVolume接口调用",value);
			_e.send(Enum.PLAY_VOLUME,value);	
		}
	}
}