package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenMax;
	import com.idzier.bussies.AssiBgPictor;
	import com.idzier.bussies.MessView;
	import com.idzier.view.DebugerUI;
	import com.idzier.view.Panel;
	import com.idzier.view.VScrollPanel;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.fscommand;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.setTimeout;
	
	[SWF(width="770",height="600")]
	/**
	 * ...
	 * @author idzeir
	 */
	public class FullScreenGift extends Sprite 
	{
		private const BASE_FOLDER:String=""
		private var queue:LoaderMax;
		private var logPanel:DebugerUI;
		
		private var animationCount:uint = 0;
		private var xml:XML;
		
		private var messContainer:Sprite = new Sprite();
		private var giftContainer:Sprite = new Sprite();
		private var bgContainer:Sprite = new Sprite();
		
		private var dataMap:Vector.<Object> = new Vector.<Object>();
		private var curData:Object;
		private var isRuning:Boolean = false;
		private var view:MessView = new MessView();
		
		private const isFsCall:Boolean = false;
		
		public function FullScreenGift():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			this.addChild(bgContainer);
			this.addChild(giftContainer);
			this.addChild(messContainer);
			
			logPanel = new DebugerUI();
			logPanel.viewPort(stage.stageWidth, stage.stageHeight);			
			
			queue = new LoaderMax( {name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler} );
			
			removeEventListener(Event.ADDED_TO_STAGE, init);			
			
			checkAPI();
			
			logPanel.appendText("当前模式：" + stage.loaderInfo.parameters["debug"]);
			if (Boolean(stage.loaderInfo.parameters["debug"]))
			{
				this.opaqueBackground = 0xff0000;					
			}
			createMenu();
		}
		
		/**
		 * api校验
		 */
		private function checkAPI():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("flyGift", flyGift);
				logPanel.appendText("<font color='#ff0000'>准备api完成</font>");
				
				fscommand("flyComplete");
				if (!isFsCall) ExternalInterface.call("flyComplete");
				logPanel.appendText("<font color='#ff0000'>调用容器flyComplete</font>");
			}else {
				logPanel.appendText("准备api：容器ExternalInterface不可用");
				setTimeout(checkAPI, 500);
			}
		}
		
		private function createMenu():void
		{
			var menu:ContextMenu = new ContextMenu();
			var logItem:ContextMenuItem = new ContextMenuItem("日志");
			var authorItem:ContextMenuItem=new ContextMenuItem("隆隆_iDzeir",false,false)
			menu.customItems.push(logItem,authorItem);
			this.contextMenu = menu;
			menu.hideBuiltInItems();
			logItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showLog);
		}
		
		private function showLog(e:ContextMenuEvent):void 
		{			
			if (!this.contains(logPanel))
			{
				this.addChild(logPanel);
				return;
			}
			this.removeChild(logPanel);
		}
		
		/**
		 * 全屏飞礼物接口
		 * @param	giftName 礼物名称
		 * @param	giftURL 礼物图片名称
		 * @param	type 礼物动画XML		
		 * @param	sender 礼物发送者
		 * @param reciver 礼物接受者
		 */
		public function flyGift(giftName:String,giftURL:String,type:String,sender:String,reciver:String):void
		{
			var data:Object = { giftName:giftName, "giftURL":giftURL, "type":type, "sender":sender, "reciver":reciver };
			logPanel.appendText("<font color='#ff0000'>容器调用动画接口：【"+JSON.stringify(data)+"】</font>");
			dataMap.push(data);
			if (isRuning)
			{
				return;
			}			
			isRuning = true;
			play();
		}
		
		private function play():void
		{
			var data:Object = curData = dataMap.shift();
			animationCount = 0;
			queue.unload();
			queue.append(new XMLLoader(BASE_FOLDER + data.type, { name:"xmlDoc" } ));			
			queue.append(new ImageLoader(BASE_FOLDER + data.giftURL, { name:"ico" } ));					
			queue.load();
		}
		
		private function errorHandler(e:LoaderEvent):void 
		{
			logPanel.appendText("Error:"+e.text);
		}
		
		private function completeHandler(e:LoaderEvent):void 
		{
			logPanel.appendText("队列加载完成！");		
			
			
			var source:BitmapData = (ContentDisplay(queue.getContent("ico")).rawContent as Bitmap).bitmapData;
			
			xml = XML(queue.getContent("xmlDoc"));			
			logPanel.appendText("动画背景图片:" + BASE_FOLDER+xml.points.@bg + "||" + BASE_FOLDER+xml.points.@messBg);
			var bg:AssiBgPictor = AssiBgPictor.getAssisPictor();
			bg.background = BASE_FOLDER+xml.points.@bg;
			if (bg) bgContainer.addChildAt(AssiBgPictor.getAssisPictor(), 0);
			
			var node:XMLList = xml..point;
			animationCount=(node.length());
			for each(var i:XML in node)
			{
				var bitmap:Bitmap = new Bitmap(source);
				bitmap.scaleX = bitmap.scaleY = 1;				
				
				var rect:Rectangle = bitmap.getBounds(this);
				rect.inflate(200, 200);
				bitmap.x = Number(i.@x)+rect.left+Math.random()*rect.width;
				bitmap.y = Number(i.@y)+rect.top+Math.random()*rect.height;
				this.giftContainer.addChild(bitmap);
				
				//i.@x = uint(Number(i.@x) - 10);
				//i.@y = uint(Number(i.@y) - 10);
				TweenMax.to(bitmap, 2, {"x":Number(i.@x),"y":Number(i.@y),onComplete:onComplete } );				
			}
			//trace(xml);
		}
		
		private function onComplete():void 
		{
			if (--animationCount <= 0)
			{
				logPanel.appendText("动画播放完了");				
				view.content = { url:BASE_FOLDER + xml.points.@messBg, giftName:curData.giftName , sender:curData.sender, reciver:curData.reciver };
				this.messContainer.addChild(view);
				view.x =  Number(xml.points.@messx);
				view.y = Number(xml.points.@messy);
				setTimeout(closeFrame, 2000);
			}
		}
		
		private function closeFrame():void
		{
			bgContainer.removeChildren();
			messContainer.removeChildren();
			giftContainer.removeChildren();
			xml = null;
			curData = null;
			if (dataMap.length > 0)
			{
				logPanel.appendText("播放下一个礼物动画");
				play();
				return;
			}
			if (ExternalInterface.available)
			{
				fscommand("doClose");
				if (!isFsCall)ExternalInterface.call("doClose");
				logPanel.appendText("<font color='#ff0000'>调用容器接口关闭窗口。doClose</font>");
			}			
		}
		
		private function progressHandler(e:LoaderEvent):void 
		{
			//logPanel.appendText("加载进度："+queue.progress);
		}
	}
	
}