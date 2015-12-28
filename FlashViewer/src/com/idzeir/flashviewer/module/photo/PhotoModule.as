package com.idzeir.flashviewer.module.photo
{	
	import com.adobe.images.PNGEncoder;
	import com.idzeir.core.Context;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.interfaces.ITicker;
	import com.idzeir.core.utils.SWFPaser;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.media.SoundMixer;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	
	/**
	 * 后台生成缩略图模块
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jul 5, 2014 5:16:55 PM
	 **/
	
	public class PhotoModule extends Module
	{
		private var files:Vector.<File>;
		
		private var _loader:URLLoader;
		private var _url:URLRequest;
		private var _swfLoader:Loader;
		
		private var box:Sprite;
		
		private var _swfInfo:Object;
		
		private const WIDTH:uint = 350;
		private const HEIGHT:uint = 250;
		
		//private var _proTxt:TextField;

		private var _startup:StartupScreen;
		/**
		 * 需要生成缩略图的文件个数 
		 */		
		private var _total:int = 0;
		
		/**
		 * 生成缩略图最长时间 
		 */		
		private var _time:int = 10;
		
		public function PhotoModule()
		{
			super();
			//this.visible = false;
			files = new Vector.<File>();
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE,this.binaryCompleted);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,function():void
			{
				Logger.out(this,"加载失败IO错误");
			});
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function():void
			{
				Logger.out(this,"加载失败安全受限");
			});
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_url = new URLRequest();
			
			_startup = new StartupScreen();
			_swfLoader = new Loader();
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfReady);
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			box = new Sprite();
			/*bglayer = new Sprite();
			bglayer.graphics.beginFill(0x000000);
			bglayer.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			bglayer.graphics.endFill();*/
			
			/*_proTxt = new TextField();
			_proTxt.defaultTextFormat = new TextFormat(Utils.FONT_NAME,12,0xffff00,true);
			_proTxt.autoSize = "left";*/
			this.addChild(_startup);
			this.addChild(box);
			//this.addChild(_proTxt);
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
		
		protected function checkPhoto(event:Event=null):void
		{
			if(box.width>0&&box.height>0)
			{
				var file:File = new File(_url.url.replace(".swf",".png"));
				box.removeEventListener(Event.ENTER_FRAME,checkPhoto);
				
				box.scaleX = WIDTH/_swfInfo.width;
				box.scaleY = HEIGHT/_swfInfo.height;
				
				box.x = - box.width;
				
				var bmd:BitmapData = new BitmapData(WIDTH,HEIGHT,true,0x00ffffff);
				var matr:Matrix = new Matrix();
				matr.tx = -box.x
				bmd.draw(this,matr);
				
				var filestream:FileStream = new FileStream();
				filestream.open(file,FileMode.WRITE);
				filestream.writeBytes(PNGEncoder.encode(bmd));
				filestream.close();
				bmd.dispose();
				_swfLoader.unloadAndStop();
				
				this._e.send(Enum.CREATE_PHOTO_COMPLETE,file.nativePath);
				Logger.out(this," 生成缩略图:"+file.nativePath);
				/*this._proTxt.text = "检测到新素材："+this.files.length;
				this._proTxt.x = (stage.stageWidth - this._proTxt.width) >>1
				this._proTxt.y = (stage.stageHeight - this._proTxt.height) >>1*/
				//trace("进度信息:",this.files.length,this._total);
				this._startup.progress = int(100-100*(this.files.length/this._total));
				file = null;
				this.parsePhoto();
				box.removeChildren();
			}else if(--_time<=0){
				box.removeEventListener(Event.ENTER_FRAME,checkPhoto);
				createDefaultPNG(_url.url.replace(".swf",".png"));
			}
		}
		/**
		 * 生成默认的缩略图 
		 * @param filePath
		 * 
		 */		
		private function createDefaultPNG(filePath:String):void
		{
			var bmd:BitmapData = new BitmapData(WIDTH,HEIGHT,false,0xffffff);
			var file:File = new File(filePath);
			
			var filestream:FileStream = new FileStream();
			filestream.open(file,FileMode.WRITE);
			filestream.writeBytes(PNGEncoder.encode(bmd));
			filestream.close();
			bmd.dispose();
			_swfLoader.unloadAndStop();
			
			this._e.send(Enum.CREATE_PHOTO_COMPLETE,unescape(file.nativePath));
			Logger.out(this," 生成缩略图:"+unescape(file.nativePath));
			/*this._proTxt.text = "检测到新素材："+this.files.length;
			this._proTxt.x = (stage.stageWidth - this._proTxt.width) >>1
			this._proTxt.y = (stage.stageHeight - this._proTxt.height) >>1*/
			//trace("进度信息:",this.files.length,this._total);
			this._startup.progress = int(100-100*(this.files.length/this._total));
			file = null;
			this.parsePhoto();
			box.removeChildren();
		}
		
		/**
		 * 二进制数据转换成影片 
		 * @param event
		 * 
		 */		
		protected function swfReady(event:Event):void
		{
			flash.media.SoundMixer.stopAll();
			this._time = 10;
			box.addEventListener(Event.ENTER_FRAME,checkPhoto);
			box.addChild(_swfLoader);
		}
		
		/**
		 * 二进制数据加载完成 
		 * @param event
		 * 
		 */		
		protected function binaryCompleted(event:Event):void
		{
			_swfInfo = SWFPaser.parse(event.target.data);
			var ldr:LoaderContext = new LoaderContext(false);//,ApplicationDomain.currentDomain);
			ldr.allowCodeImport = true;
			_swfLoader.loadBytes(event.target.data,ldr);
		}
		
		public function takePhoto(file:File):void
		{
			this.visible = true;
			Logger.out(this,"根目录："+file.nativePath);
			getSWF(file);
		}
		
		private function getSWF(value:File):void
		{
			var rootFolder:Array = value.getDirectoryListing().filter(getDirectory);
			
			var secondFolder:Array = [];
			rootFolder.forEach(function(e:File,index:int,arr:Array):void
			{
				var folder:Array = e.getDirectoryListing().filter(getDirectory)
				folder.forEach(function(s:File,index:int,arr:Array):void
				{
					secondFolder.push(s);
				})
			});
			
			var swfs:Array = [];
			var pngs:Array = [];
			
			secondFolder.forEach(function(e:File,index:int,arr:Array):void
			{
				getFilesByType(e).forEach(function(e:File,index:int,arr:Array):void
				{
					swfs.push(e);
					var path:String = e.url;
					var pngURL:String = path.replace(".swf",".png");
					if(!new File(pngURL).exists)
					{
						pngs.push(e);
					}
				});
			});
			
			pngs.forEach(function(e:File,index:int,arr:Array):void
			{
				files.push(e);
			});
			if (pngs.length>0)
			{
				Logger.out(this," 检测到新资源开始生成的缩略图");
				_total = pngs.length;
				parsePhoto();
			}else{
				Logger.out(this," 无需生成缩略图，展示开始画面");	
				this._startup.info = "检测资源库内容...";
				
				var ticker:ITicker = (Context.getContext("ticker") as ITicker);
				ticker.call(2000,function():void
				{
					visible = false;
					_e.send(Enum.READY_INIT);
				},1);
				ticker.call(1500,function():void
				{
					_startup.info = "检测完毕";
				},1);
			}			
		}
		
		public function noFolderFound(value:String = ""):void
		{
			this._startup.errorInfo = "<font color='#ff0000'>安装目录下未找到资源文件夹source</font>";
		}
		
		private function parsePhoto():void
		{
			if(this.files.length>0)
			{
				var file:File = this.files.shift();
				_url.url = (file.url);
				var pngURL:String = _url.url.replace(".swf",".png");
				if(!new File(pngURL).exists)
				{
					//trace("TMD:",_url.url);
					_loader.load(_url);
					return;
				}
				
				parsePhoto();
				return
			}
			Logger.out(this," 全部缩略图生成完毕");
			_startup.info = "执行完毕";
			(Context.getContext("ticker") as ITicker).call(1500,function():void
			{
				visible = false;
				_e.send(Enum.READY_INIT);
			},1);
		}
		
		private function getFilesByType(file:File,type:String="swf"):Array
		{
			var swfs:Array = file.getDirectoryListing().filter(function(e:File,index:int,map:Array):Boolean
			{
				return e.extension == type;
			})
			return swfs;
		}
		
		private function getDirectory(e:File,index:int,arr:Array):Boolean
		{
			return e.isDirectory
		}
	}
}