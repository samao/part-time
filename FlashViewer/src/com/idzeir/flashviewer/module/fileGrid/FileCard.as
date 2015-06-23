package com.idzeir.flashviewer.module.fileGrid
{	
	import com.idzeir.assets.DeleteSP;
	import com.idzeir.assets.OpenFolderSP;
	import com.idzeir.assets.TitleSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.VGroup;
	import com.idzeir.flashviewer.bussies.common.FilterButton;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 5:17:55 PM
	 *
	 **/
	
	public class FileCard extends Module
	{
		static public const CARD_WIDTH:uint = 155;
		static public const CARD_HEIGHT:uint = 180;

		private var nameTxt:TextField;

		private var oPos:Object;

		private var _info:Object;

		private var viewPicture:ViewPicture;
		
		private var _content:VGroup;

		private var fileRef:File;

		private var file:File;
		
		private var _p:Point = new Point();
		
		public function FileCard()
		{
			super();
			//this.mouseChildren = false;
			fileRef = new File();
		}
		
		/**
		 * 动画的结束坐标 
		 * @param _x
		 * @param _y
		 * 
		 */		
		public function setXY(_x:Number,_y:Number):void
		{
			_p.x = _x;
			_p.y = _y;
		}
		
		public function get OX():Number
		{
			return _p.x;
		}
		
		public function get OY():Number
		{
			return _p.y;
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			drawBglayer();
			_content = new VGroup();
			_content.gap = 8;
			_content.align = VGroup.CENTER;
			_content.top = 5;
			this.addChild(_content);
			var titleBg:TitleSP = new TitleSP();
			titleBg.filters = [new DropShadowFilter(5,90,0,.15),new DropShadowFilter(5,0,0,.15),new DropShadowFilter(5,180,0,.15)];
			titleBg.width = CARD_WIDTH;
			
			//文件名
			nameTxt = new TextField();
			nameTxt.mouseEnabled = false;
			nameTxt.defaultTextFormat = new TextFormat(Utils.FONT_NAME,12,null,true);
			nameTxt.width = CARD_WIDTH;
			nameTxt.height = titleBg.height;
			nameTxt.autoSize = TextFieldAutoSize.CENTER;
			nameTxt.text = " ";
			nameTxt.y = (titleBg.height - nameTxt.textHeight)>>1;
			titleBg.addChild(nameTxt);
			_content.addChild(titleBg);
			
			//预览图
			viewPicture = new ViewPicture();
			_content.addChild(viewPicture);
			//操作按钮
			var delBut:FilterButton = new FilterButton("复制",onCopy);
			delBut.bglayer = new DeleteSP();
			
			var openFolderBut:FilterButton = new FilterButton("打开目录",function():void
			{
				var file:File = new File(_info.url).parent;
				try{
					file.openWithDefaultApplication();
				}catch(e:Error){
					//trace(e.message);
					_e.send(Enum.ERROR_INFO,"操作系统禁止此权限运行");
				}
			});
			openFolderBut.bglayer = new OpenFolderSP();
			
			delBut.y = this.height - delBut.height + 8;
			openFolderBut.x = this.width - openFolderBut.width;
			openFolderBut.y = delBut.y;
			delBut.over = openFolderBut.over = true;
			
			this.addChild(delBut);
			this.addChild(openFolderBut);
			
			viewPicture.addEventListener(MouseEvent.CLICK,openFloder);
		}
		
		private function onCopy(event:MouseEvent):void
		{
			var swfURL:String = _info.url;
			
			file = new File(swfURL.replace(".swf",".fla"));
			if(file.exists)
			{
				file.addEventListener(Event.COMPLETE,onFileLoaded);
				
				if(!Utils.vars["folder"]||!new File(Utils.vars.folder).exists)
				{
					fileRef.addEventListener(Event.SELECT,onSelected);
					fileRef.browseForDirectory("选择保存文件夹");
					return;
				}
				file.load();
			}else{
				_e.send(Enum.ERROR_INFO,"指定swf文件的fla源文件不存在，或者与swf文件不同名");
			}
		}
		
		protected function onFileLoaded(event:Event):void
		{
			file.removeEventListener(Event.COMPLETE,onFileLoaded);
			save();
		}
		
		private function save():void
		{
			if(Utils.vars["folder"]&&new File(Utils.vars.folder).exists)
			{
				var filePath:String = Utils.vars.folder+"/"+file.name;
				var saveRef:File = new File(filePath);
				var retry:uint = 0;
				while(saveRef.exists)
				{
					saveRef = new File(filePath.replace(".fla","_"+(++retry)+".fla"));
				}
				var fs:FileStream = new FileStream();
				fs.open(saveRef,FileMode.WRITE);
				fs.writeBytes(file.data);	
				fs.close();
				file = null;
				_e.send(Enum.ERROR_INFO,"文件提取成功："+saveRef.nativePath);
			}else{
				_e.send(Enum.ERROR_INFO,"指定保存目录不存在，请按shift+ctrl+s清除记录重新选择目录。或者重启软件");
			}
		}
		
		protected function onSelected(event:Event):void
		{
			fileRef.removeEventListener(Event.SELECT,onSelected);
			Utils.vars.folder = (fileRef.nativePath);
			file.load();
		}
		
		protected function openFloder(event:MouseEvent):void
		{
			_e.send(Enum.PREVIEW_FILE,_info.url);
		}
		
		private function drawBglayer():void
		{
			this.graphics.beginFill(0x4c4c4c,0);
			this.graphics.drawRect(0,0,CARD_WIDTH,CARD_HEIGHT);
			this.graphics.endFill();
		}
		
		public function get url():String
		{
			return _info.url;
		}
		
		public function info(value:Object):void
		{
			if(!oPos)oPos = {x:this.x,y:this.y};
			_info = value;
			nameTxt.text = (value).name.replace(".swf","");
			var pUrl:String = value.url;
			viewPicture.url = pUrl.replace(".swf",".png");
			alpha = 0;
			//y = oPos.y - 20;
			Utils.tween.killTweensOf(this);
			Utils.tween.to(this,.5,{alpha:1,onComplete:onMotionFinished});
		}
		
		public function set selected(bool:Boolean):void
		{
			this.viewPicture.selected = bool;
		}
		
		private function onMotionFinished():void
		{
			this.x = oPos.x;
			this.y = oPos.y;
		}
	}
}