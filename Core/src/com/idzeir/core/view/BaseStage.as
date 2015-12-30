package com.idzeir.core.view
{
	import com.idzeir.core.Context;
	import com.idzeir.core.bussies.SceneElement;
	import com.idzeir.core.bussies.enum.FEnum;
	import com.idzeir.core.events.IMediator;
	import com.idzeir.core.events.Mediator;
	import com.idzeir.core.interfaces.ITicker;
	import com.idzeir.core.motion.Tween;
	import com.idzeir.core.utils.Ticker;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class BaseStage extends Sprite
	{
		protected var _e:IMediator;
		
		private var logPanel:DebugerUI;
		
		/**
		 * 是否开启日志模式
		 */
		protected var _debug:Boolean = true;
		/**
		 * 缓存显示对象等待初始化界面消息 
		 */		
		protected var _sceneElementMap:Vector.<SceneElement> = new Vector.<SceneElement>();
		
		public function BaseStage()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,this.init);
			
			parseFlashvars();
			parseURLParams();
			
			logPanel = new DebugerUI();
			Logger._ilog = logPanel;
			logPanel.viewPort(stage.stageWidth, stage.stageHeight);	
			
			createMenu();
			
			Utils.tween = new Tween();
			Utils.fixMediator(new Mediator());
			_e = Utils.mediator;
			_e.watch(FEnum.SWITCH_TICKER,function(value:*):void
			{
				userTicker = value;
			});
			userTicker = true;
		}
		/**
		 * 解析flashvars数据
		 */		
		private function parseFlashvars():void
		{
			if(stage.loaderInfo.parameters)
			{
				var ob:Object = stage.loaderInfo.parameters;
				for(var i:String in ob)
				{
					Context.variables[i] = ob[i];
				}
			}
		}
		
		/**
		 * 解析web数据，url后缀会覆盖flashvars
		 */
		private function parseURLParams():void
		{
			var ref:String = Utils.refPage;
			var p:Object = Context.variables;
			if (!Utils.validateStr(ref)) return;
			
			var split:Array = ref.split("?");
			if (split.length > 1) {
				//取问号后面
				var paramStr:String = split[1];
				if (Utils.validateStr(paramStr)) {
					//按&分隔
					var params:Array = paramStr.split("&");
					for each (var pair:String in params) {
						//按=分隔
						var pairSplit:Array = pair.split("=");
						//如果分隔成功,就可以当成key=value来解析了
						if (pairSplit.length > 1) {
							p[pairSplit[0]] = pairSplit[1];
						}
					}
				}
			}
		}
		
		protected function setDebugPort(w:Number,h:Number):void
		{
			logPanel.viewPort(w,h);
		}
		
		/**
		 * 选择性接入计时器 
		 * @param bool true为使用，false为禁用
		 * 
		 */		
		protected function set userTicker(bool:Boolean):void
		{
			if(bool)
			{
				if(!Context.getContext("ticker"))
				{
					Context.register("ticker",Ticker);
				}
				(Context.getContext("ticker") as ITicker).start();
			}else{
				(Context.getContext("ticker") as ITicker).stop();
			}
		}
		
		protected function createMenu():void
		{
			var menu:ContextMenu = new ContextMenu();
			var logItem:ContextMenuItem = new ContextMenuItem("日志",false,_debug);
			var authorItem:ContextMenuItem=new ContextMenuItem("隆隆_iDzeir")
			menu.customItems.push(logItem,authorItem);
			this.contextMenu = menu;
			menu.hideBuiltInItems();
			authorItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, gotoAuthor);
			logItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showLog);
		}
		
		private function gotoAuthor(e:ContextMenuEvent):void 
		{			
			Utils.toURL("http://t.qq.com/idzeir");
		}
		
		protected function showLog(e:ContextMenuEvent):void 
		{			
			if (!this.contains(logPanel))
			{
				this.addChild(logPanel);
				return;
			}
			this.removeChild(logPanel);
		}
	}
}