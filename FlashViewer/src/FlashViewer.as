package
{	
	import com.idzeir.assets.BackgroundBD;
	import com.idzeir.assets.EffectMP;
	import com.idzeir.core.Context;
	import com.idzeir.core.bussies.DelegateManager;
	import com.idzeir.core.bussies.IModule;
	import com.idzeir.core.bussies.SceneElement;
	import com.idzeir.core.bussies.enum.FEnum;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.BaseStage;
	import com.idzeir.core.view.Logger;
	import com.idzeir.core.view.Panel;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	import com.idzeir.flashviewer.context.AlertMap;
	import com.idzeir.flashviewer.module.ad.TaoBaoAdDelegate;
	import com.idzeir.flashviewer.module.error.ErrorDelegate;
	import com.idzeir.flashviewer.module.fileGrid.FileGridDelegate;
	import com.idzeir.flashviewer.module.fileTree.FileTreeDelegate;
	import com.idzeir.flashviewer.module.guide.GuideDelegate;
	import com.idzeir.flashviewer.module.logo.LogoDelegate;
	import com.idzeir.flashviewer.module.photo.PhotoDelegate;
	import com.idzeir.flashviewer.module.preview.PreViewDelegate;
	import com.idzeir.flashviewer.module.register.RegisterModuleDelegate;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	
	/**
	 * flash资源管理器
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 16, 2014 10:58:47 PM
	 **/
	[SWF(width="1024",height="512",frameRate="24",backgroundColor="0x000000")]
	public class FlashViewer extends BaseStage
	{
		public const VERSION:String = "20151230";
		
		private var _view:Panel;
		
		public function FlashViewer()
		{
			super();
		}
		
		override protected function init(e:Event=null):void
		{
			super.init(e);
			
			Context.register("Alert",AlertMap,stage);
			
			_e.watch(FEnum.FW_LOAD_COMPLETED,onModuleLoaded);
			
			var dm:DelegateManager = new DelegateManager();
			dm.register(new FileTreeDelegate());
			dm.register(new LogoDelegate());
			dm.register(new TaoBaoAdDelegate());			
			dm.register(new FileGridDelegate());
			dm.register(new PreViewDelegate());
			dm.register(new ErrorDelegate());
			dm.register(new PhotoDelegate());
			dm.register(new RegisterModuleDelegate());
			dm.register(new GuideDelegate());
			dm.excute();
			
			stage.addEventListener(KeyboardEvent.KEY_UP,function(ke:KeyboardEvent):void
			{
				if(ke.keyCode == flash.ui.Keyboard.S&&ke.shiftKey&&ke.ctrlKey&&Utils.vars["folder"])
				{
					_e.send(Enum.ERROR_INFO,"清除上次保存路径记录");
					delete Utils.vars["folder"];
				}
				Logger.out("内存：",Number(flash.system.System.freeMemory/1024/1024).toFixed(2)+"m","CPU:",System.processCPUUsage);
			});
			
			logInfo();
			Logger.out(this," 初始化信息完成,进行加载模块");
			
			_e.watch(FEnum.FW_ALL_LOADED,initComplete);
			_e.watch(Enum.SUCCESS_REGISTER,gotoEnter);
		}
		
		override protected function createMenu():void
		{
			var _status:Boolean = false;
			this.contextMenu = new ContextMenu();
			var version:ContextMenuItem = new ContextMenuItem("发布版本："+VERSION,false,false);
			var author:ContextMenuItem = new ContextMenuItem("软件开发：iDzeir",false,false);
			var log:ContextMenuItem = new ContextMenuItem("日志开关："+(_status?"开":"关"),false,true);
			log.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(e:ContextMenuEvent):void
			{
				_status = !_status;
				log.caption = "日志开关："+(_status?"开":"关");
				showLog(e);
			});
			var contact:ContextMenuItem = new ContextMenuItem("问题反馈：烽羽漫天",false,true);
			contact.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void
			{
				Utils.toURL("https://fengyumantian.taobao.com/");
			});
			contextMenu.items.push(version,author,log,contact);
		}
		
		private function gotoEnter(value:* = null):void
		{
			while(this._sceneElementMap.length)
			{
				this._sceneElementMap.shift().add();
			}
			_e.remove(Enum.SUCCESS_REGISTER,gotoEnter);
		}
		
		private function initComplete(value:* = null):void
		{
			_e.remove(FEnum.FW_ALL_LOADED,initComplete);
			
			//_e.send(Enum.ERROR_INFO,"错误了吧");
		}
		
		private function logInfo():void
		{
			Logger.unTimeLog("==============================");
			Logger.unTimeLog("FlashViewer");
			Logger.unTimeLog("Version:beta "+VERSION);
			Logger.unTimeLog("Author:"+"<a href='http://t.qq.com/idzeir'><font color='#ff0000'>idzeir</font></a>");
			Logger.unTimeLog("E-mail: qiyanlong@wozine.com");
			Logger.unTimeLog("System:"+flash.system.Capabilities.os);
			Logger.unTimeLog("LocalFileReadDisable:"+flash.system.Capabilities.localFileReadDisable);
			Logger.unTimeLog("==============================");
		}
		
		private function onModuleLoaded(value:DisplayObject):void
		{
			if(!_view)
			{
				_view = new Panel();
				_view.mouseEnabled = false;
				this.mouseEnabled = false;
				var mc:MovieClip = new EffectMP();
				mc.x = ((stage.stageWidth)>>1);
				mc.y = (stage.stageHeight)>>1;
				_view.addRawChildAt(mc,0);
				
				var bg:Bitmap = new Bitmap(new BackgroundBD());
				bg.width = stage.stageWidth;
				bg.height = stage.stageHeight;
				
				_view.addRawChildAt(bg,0);
				this.addChild(_view);
				_view.backgroundColor(0x00ff00,.0);
				_view.viewPort(stage.stageWidth,stage.stageHeight);
			}
			var element:SceneElement = SceneElement.create(value);
			_view.addChild(element);
			var module:IModule = value as IModule;
			if(module.name == "RegisterModule.swf"||module.name == "GuideModule.swf")
			{
				element.add();
			}else{
				_sceneElementMap.push(element);
			}
		}
	}
}