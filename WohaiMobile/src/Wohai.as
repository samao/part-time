package
{
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.buissnes.InitAnchor;
	import com.idzeir.buissnes.InitLobby;
	import com.idzeir.buissnes.InitRtmp;
	import com.idzeir.core.motion.Tween;
	import com.idzeir.events.EventMap;
	import com.idzeir.events.InfoEvent;
	import com.idzeir.manager.RoomManager;
	import com.idzeir.service.HttpService;
	import com.idzeir.view.AchorRoom;
	import com.idzeir.view.AnchorStatus;
	import com.idzeir.view.BackgroundLayer;
	import com.idzeir.view.IRender;
	import com.idzeir.view.Lobby;
	import com.idzeir.view.VideoMasker;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[SWF(backgroundColor="#ffffff"]
	public class Wohai extends Sprite
	{
		/**
		 * 缩放的对象必须实现irender接口 
		 */		
		private var childs:Vector.<IRender>;
		
		private var bglayer:BackgroundLayer;
		private var lobby:Lobby;
		private var achorRoom:AchorRoom;
		
		private var keyMap:Array = [];

		private var id:int;

		private var videomasker:VideoMasker;
		
		public function Wohai()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.focus = this;
			
			flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.TOUCH_POINT;
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			childs = new Vector.<IRender>();
			
			//全局引用
			G.h = new HttpService();
			G.e = EventMap.map();
			G.r = new RoomManager();
			G.t = new Tween();
		}
		
		protected function onAdded(event:Event):void
		{
			stage.addEventListener(Event.RESIZE,onResizeHandler);
			//禁止屏保待机
			flash.desktop.NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			bglayer ||= new BackgroundLayer();
			lobby ||= new Lobby();
			achorRoom ||= new AchorRoom();			
			videomasker ||= new VideoMasker();
				
			this.addChild(bglayer);
			this.addChild(achorRoom);
			this.addChild(videomasker);
			this.addChild(lobby);
			
			/*this.addChild(new ReflushButton("刷新",function():void
			{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:"getLobby"}));
			}));*/
			
			this.addChild(new AnchorStatus());
			
			videomasker.y = achorRoom.height - 57;
			lobby.y = achorRoom.y + achorRoom.height;
			lobby.port = new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight - achorRoom.height - 40);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void
			{
				e.stopImmediatePropagation();
				e.stopPropagation();
				clearTimeout(id);
				if(e.keyCode == flash.ui.Keyboard.BACK)
				{
					e.preventDefault();
					keyMap.length<2&&keyMap.push(e.keyCode);
					checkExit()
				}
			});
			
			initBuissnes();
		}
		
		protected function initBuissnes():void
		{
			new InitLobby();
			new InitAnchor();
			new InitRtmp();
			//new InitChatProxy();
		}
		
		private function checkExit():void
		{
			if(keyMap.length>=2)
			{
				flash.desktop.NativeApplication.nativeApplication.exit();
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"再按一次退出"}));
				id = setTimeout(function():void{
					keyMap.shift();
				},1500);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var result:DisplayObject = super.addChild(child);
			if(child is IRender)
			{
				childs.push(child);
			}
			return result
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var result:DisplayObject = super.removeChild(child);
			if(child is IRender)
			{
				var index:int = childs.indexOf(child as IRender);
				if(index!=-1)
				{
					childs.splice(index,1);
				}
			}
			return result
		}
		
		override public function removeChildren(beginIndex:int=0, endIndex:int=2147483647):void
		{
			super.removeChildren(beginIndex,endIndex);
			childs.length = 0;
		}
		
		protected function onResizeHandler(event:Event):void
		{
			for each(var i:IRender in childs)
			{
				i.warp.visible = false;
				i.resize();
				i.warp.visible = true;
			}
		}
	}
}