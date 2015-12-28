package com.idzeir.flashviewer.module.preview
{	
	import com.adobe.images.PNGEncoder;
	import com.idzeir.assets.FullScreenSP;
	import com.idzeir.assets.PreviewSWFLoadingSP;
	import com.idzeir.core.Context;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.interfaces.ITicker;
	import com.idzeir.core.utils.SWFPaser;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.HGroup;
	import com.idzeir.core.view.Logger;
	import com.idzeir.core.view.TabBar;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 20, 2014 10:43:55 PM
	 *
	 **/
	
	public class PreViewModule extends Module
	{
		private var loader:URLLoader;
		private var _path:URLRequest = new URLRequest();
		private var swf:Loader;
		private var box:Sprite;

		private var swfInfo:Object;
		
		private var view:Object;

		private var _mask:Shape;

		private var fullScreenBut:Button;

		private var close:Button;
		
		private var _showPos:Point;
		
		private var _speed:Number = 1;
		
		private var _vecTxt:TextField;

		private var tips:TextField;
		
		private var _leftTop:HGroup;

		private var loading:Sprite;

		public function PreViewModule()
		{
			super();
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
		
		override protected function onAdded(event:Event):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			var bglayer:Sprite = new Sprite();
			bglayer.graphics.beginFill(0x000000);
			bglayer.graphics.drawRect(0,0,720,400);
			bglayer.graphics.endFill();
			this.addChild(bglayer);
			
			_leftTop = new HGroup();
			_leftTop.valign = HGroup.MIDDLE;
			
			this.x = 280;
			this.y = 30;
			_showPos = new Point(this.x,this.y);
			
			view = {};
			view.width = this.width;
			view.height = this.height;
			
			this.visible = false;
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,onDataLoaded);
			
			swf = new Loader();
			swf.contentLoaderInfo.addEventListener(Event.COMPLETE,loadSWFHandler);
			
			box = new Sprite();
			
			_mask = new Shape();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0,0,view.width,view.height);
			_mask.graphics.endFill();
			
			close = new Button("X",function(e:MouseEvent):void
			{
				e.stopImmediatePropagation();
				e.stopPropagation();
				easeOut();
			});
			
			this.addChild(close);
			this.addChild(box);
			
			close.useHandCursor = false;
			close.x = view.width - close.width - 5;
			close.y = 5+2;
			
			fullScreenBut = new Button("全屏",function(e:MouseEvent):void
			{		
				e.stopImmediatePropagation();
				e.stopPropagation();
				if(fullScreenBut.label == "全屏")
				{
					fullScreen = true;
				}else{
					fullScreen = false;
				}
			});
			fullScreenBut.bglayer = new FullScreenSP();
			fullScreenBut.over = true;
			this.addChild(fullScreenBut);
			fullScreenBut.x = close.x  - fullScreenBut.width - 10;
			fullScreenBut.y = close.y;
			
			_vecTxt = new TextField();
			_vecTxt.autoSize = "left";
			_vecTxt.defaultTextFormat = new TextFormat(Utils.FONT_NAME,12,0xffff00,true);
			_vecTxt.text = "速度："+Math.ceil(_speed*100)+"%";
			
			tips = new TextField();
			tips.autoSize = "left";
			tips.defaultTextFormat = new TextFormat(Utils.FONT_NAME,12,0xff0000,true);
			tips.text = "Tips："+"预览时按下alt键可以生成即时的缩略图哦！";
			tips.x = (this.width - tips.width)>>1;
			tips.y = 5;
			this.addChild(tips);
			
			_vecTxt.filters = tips.filters = [new GlowFilter(0x000000,1,2,2,1)];
			_vecTxt.mouseEnabled = tips.mouseEnabled = false;
			
			stage.addEventListener(KeyboardEvent.KEY_UP,function(ke:KeyboardEvent):void
			{
				if(visible)
				{
					if(ke.keyCode == flash.ui.Keyboard.ESCAPE)
					{
						fullScreen = false;
					}
					if(ke.keyCode == Keyboard.ALTERNATE)takePhoto();
					
					if(ke.keyCode == Keyboard.UP)
					{
						_speed += 0.1;
						speed = Math.min(5,_speed);
					}
					
					if(ke.keyCode == Keyboard.DOWN)
					{
						_speed -= 0.1;
						speed = Math.max(.5,_speed);
					}
				}				
			});
			
			
			var tab:TabBar = new TabBar(TabButtonSkin);
			var arr:Vector.<Object> = Vector.<Object>([{"label":"黑",data:0x000000},{"label":"白",data:0xffffff}]);
			tab.dataProvider = arr;
			
			_leftTop.addChild(tab);
			_leftTop.addChild(_vecTxt);
			
			tab.addEventListener(Event.CHANGE,function():void
			{
				bglayer.graphics.clear();
				bglayer.graphics.beginFill(arr[tab.index].data);
				bglayer.graphics.drawRect(0,0,720,400);
				bglayer.graphics.endFill();
			});
			
			this.addChild(_leftTop);
			
			loading = new PreviewSWFLoadingSP();
			loading.visible = false;
			this.addChild(loading);
		}
		
		public function set speed(value:Number):void
		{
			_speed = Number(value.toFixed(1));
			if(stage&&this.swfInfo)
			{
				stage.frameRate = uint(Number(this.swfInfo.fps)*_speed);
				//trace("_speed:",_speed);
				_vecTxt.text = "速度："+Math.ceil(_speed*100)+"%";
			}
		}
		
		private function set fullScreen(bool:Boolean):void
		{
			if(bool)
			{
				var rect:Rectangle = _mask.getRect(stage);
				stage.fullScreenSourceRect = rect;
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				fullScreenBut.label = "还原";
				//this.close.visible = false;
				//box.addEventListener(MouseEvent.CLICK,onBoxClick);
			}else{
				stage.fullScreenSourceRect = null;
				stage.displayState = StageDisplayState.NORMAL;
				fullScreenBut.label = "全屏";
				//this.close.visible = true;
				//box.removeEventListener(MouseEvent.CLICK,onBoxClick);
			}
		}
		
		protected function onBoxClick(event:MouseEvent):void
		{
			fullScreen = false;
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		private function easeOut():void
		{
			close.graphics.clear();
			(Context.getContext("ticker") as ITicker).remove(this.missTips);
			Utils.tween.killTweensOf(this);
			Utils.tween.fromTo(this,1,{alpha:1,x:this.x},{alpha:.5,x:stage.stage.width,"onComplete":onHiden});
		}
		private function onHiden():void
		{
			//trace("wanl");
			stage.displayState = StageDisplayState.NORMAL;
			fullScreenBut.label = "全屏"
			box.mask = null;
			swf.unloadAndStop();
			box.removeChildren();
			x = _showPos.x;
			//this.speed = 1;
			//stage.frameRate = 24;
			visible = false;
			//覆盖鼠标状态
			Mouse.show();
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function missTips(value:*):void
		{
			tips.visible = false;
		}
		
		protected function loadSWFHandler(event:Event):void
		{
			loading.visible = false;
			tips.visible = true;
			(Context.getContext("ticker") as ITicker).call(3000,missTips,1);
			box.removeChildren();
			box.addChild(swf);
			box.scaleX = view.width/swfInfo.width;
			box.scaleY = view.height/swfInfo.height;
			
			var realRatio:Number = Math.min(box.scaleX,box.scaleY);
			box.scaleX = box.scaleY = realRatio;
			box.x = (view.width - swfInfo.width*box.scaleX)*.5;
			box.y = (view.height - swfInfo.height*box.scaleY)*.5;
			
			speed = this._speed;
			
			box.mask = _mask;
			_mask.width = swfInfo.width*box.scaleX;
			_mask.height = swfInfo.height*box.scaleY;
			_mask.x = box.x;
			_mask.y = box.y;
			
			this.close.alpha = 0;
			//this.close.width = _mask.width;
			//this.close.height = _mask.height;
			this.close.x = _mask.x;
			this.close.y = _mask.y;
			
			this._leftTop.x = _mask.x + 5;
			
			this.fullScreenBut.x = _mask.x + _mask.width - this.fullScreenBut.width - 5;
			this.fullScreenBut.y = _mask.y + 5;
			this.addChild(_mask);
			var file:File = new File(_path.url.replace(".swf",".png"));
			
			if(!file.exists)
			{
				takePhoto();
			}
			
			var local:Point = this.close.globalToLocal(new Point());
			close.graphics.clear();
			close.graphics.beginFill(0xff0000,.3);
			close.graphics.drawRect(local.x,local.y,stage.stageWidth,stage.stageHeight);
			close.graphics.endFill();
			
			Utils.tween.fromTo(this,1,{alpha:.5,x:stage.stage.width+this.width},{alpha:1,x:this._showPos.x,onStart:function():void{
				visible = true;				
			}});
		}
		
		private function takePhoto():void
		{
			if(!box.hasEventListener(Event.ENTER_FRAME))
			{
				box.addEventListener(Event.ENTER_FRAME,checkPhoto);
			}
		}
		
		protected function checkPhoto(event:Event=null):void
		{
			if(box.width>0&&box.height>0)
			{
				var file:File = new File(_path.url.replace(".swf",".png"));
				box.removeEventListener(Event.ENTER_FRAME,checkPhoto);
				var bmd:BitmapData = new BitmapData(_mask.width,_mask.height,true,0x00ffffff);
				var matr:Matrix = new Matrix();
				matr.translate(-_mask.x,-_mask.y);
				_leftTop.visible = tips.visible = close.visible = this.fullScreenBut.visible = false;
				bmd.draw(this,matr);
				
				var filestream:FileStream = new FileStream();
				filestream.open(file,FileMode.WRITE);
				filestream.writeBytes(PNGEncoder.encode(bmd));
				filestream.close();
				bmd.dispose();
				
				_e.send(Enum.CREATE_PHOTO_COMPLETE,file.nativePath);
				file = null;
			}
			_leftTop.visible = tips.visible = close.visible = this.fullScreenBut.visible = true;
		}
		
		protected function onDataLoaded(event:Event):void
		{
			onBytesReady(loader.data);
		}
		
		/**
		 * 解析swf文件二进制数据
		 * @param bytes
		 */		
		protected function onBytesReady(bytes:ByteArray):void
		{
			swfInfo = SWFPaser.parse(bytes);
			Logger.out(this,JSON.stringify(swfInfo));
			var ldr:LoaderContext = new LoaderContext(false);
			ldr.allowCodeImport = true;
			swf.unloadAndStop();
			try{
				throw new Error("垃圾回收");
			}catch(e:Error){};
			swf.loadBytes(bytes,ldr);
		}
		
		public function play(url:String):void
		{
			Logger.out(this,"播放：",url);
			_path.url = url;
			
			loading.visible = true;
			loading.scaleX = loading.scaleY = .6;
			loading.x = view.width - loading.width>>1;
			loading.y = view.height - loading.height>>1;
			var file:File = new File(url);
			if(file.exists)
			{
				file.addEventListener(Event.COMPLETE,function():void
				{
					file.removeEventListener(Event.COMPLETE,arguments.callee);
					onBytesReady(file.data);
				});
				file.load();
			}
			//loader.load(_path);
		}

	}
}