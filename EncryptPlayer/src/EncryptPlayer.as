package
{
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.bussies.notiy.INotiy;
	import com.idzeir.bussies.notiy.NotiyBoard;
	import com.idzeir.bussies.welcome.WelcomeScreen;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.BaseStage;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	[SWF(width="800",height="600",frameRate="24",backgroundColor="#666666"]
	public class EncryptPlayer extends BaseStage
	{
		private var _body:Sprite;
		
		private var ratioX:Number = 1;
		private var ratioY:Number = 1;
		
		public function EncryptPlayer()
		{
			
		}
		override protected function init(e:Event=null):void
		{
			super.init(e);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,onConfig);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,function():void
			{
				showError("配置文件加载失败！");
			});
			urlloader.load(new URLRequest("config.ini"));			
		}
		
		override protected function createMenu():void
		{
			
		}
		
		protected function onConfig(event:Event):void
		{
			var loader:URLLoader = event.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE,this.onConfig);
			var config:Object =JSON.parse(event.target.data);			
			var rect:Rectangle = stage.nativeWindow.bounds;
			var borderW:Number = rect.width - stage.stageWidth;
			var borderH:Number = rect.height - stage.stageHeight;
			var w:Number = config.width+borderW;
			var h:Number = config.height+borderH;
			
			stage.nativeWindow.title = "Flash加密播放器_idzeir";
			stage.frameRate = config.fps;

			stage.nativeWindow.bounds = new Rectangle((stage.fullScreenWidth - w)>>1 , (stage.fullScreenHeight-h)>>1, w, h);
			
			this.ratioX = 800/config.width;
			this.ratioY = 600/config.height;
			_body = new Sprite();
			this.addChild(_body);
			//切换界面
			_e.watch(Enum.CHANGE_SCREEN,onChangeScreen);
			//错误消息
			_e.watch(Enum.ERROR,showError);
			//缩放加载元素
			_e.watch(Enum.TO_SCALE,onScaleMovie);
			
			/*Utils.valid(function():void
			{
				//通过权限验证默认欢迎界面
				_e.send(Enum.CHANGE_SCREEN,WelcomeScreen);
			},function(value:String = ""):void
			{
				_e.send(Enum.ERROR,value);
			});	*/	
			_e.send(Enum.CHANGE_SCREEN,WelcomeScreen);
		}
		
		private function onScaleMovie(value:DisplayObject):void
		{
			value.scaleX = this.ratioX;
			value.scaleY = this.ratioY;
		}
		
		private function showError(code:String = ""):void
		{
			var child:DisplayObject = Utils.getContent(NotiyBoard);			
			this.addChild(child);
			(child as INotiy).text = code;			
			fixChild(child);		
		}
		
		private function onChangeScreen(toScreen:Class):void
		{
			if(!Utils.isSupport)
			{
				_e.send(Enum.ERROR,"不支持当前系统使用");
				return;
			}
			trace("界面：",toScreen);
			_body.removeChildren();
			var child:DisplayObject = Utils.getContent(toScreen);			
			_body.addChild(child);
			fixChild(child);
		}
		
		private function fixChild(child:DisplayObject):void
		{
			if(Utils.windowOS){
				child.scaleX = this.ratioX;
				child.scaleY = this.ratioY;
			}	
		}
	}
}