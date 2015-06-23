package com.idzeir.bussies.manager
{
	import com.greensock.TweenMax;
	import com.hurlant.util.Base64;
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.Panel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class ManagerModule extends Sprite
	{
		
		private var enBut:Button;

		private var panel:Panel;

		private var file:File;
		
		private var loadTxt:TextField;
		
		private var percent:String = "";

		private var saveData:File;
		
		public function ManagerModule()
		{
			super();
			enBut = new Button("加密",enHandler);
			panel = new Panel();			
			panel.addChild(enBut);
			
			loadTxt = new TextField();
			loadTxt.mouseEnabled = false;
			loadTxt.autoSize = "left";
			loadTxt.defaultTextFormat = new TextFormat(Utils.FONT_NAME,15,0xffffff,true);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function enHandler(e:MouseEvent):void
		{
			file = new File();
			file.addEventListener(Event.SELECT,onSelected,false,0,true);
			file.browse([Utils.fileFilter]);
		}
		
		protected function onSelected(event:Event):void
		{
			if(file.size>300*1024*1024)
			{
				loadTxt.text = "文件不能大于200M";
				loadTxt.x = (stage.stageWidth-loadTxt.width)>>1;
				loadTxt.y = (stage.stageHeight-loadTxt.height)>>1;
				this.removeChildren();
				this.addChild(loadTxt);	
				setTimeout(function():void
				{
					removeChildren();
					addChild(panel);
				},1000);
				return;
			}
			this.removeChild(panel);
			file.addEventListener(ProgressEvent.PROGRESS,processHandler,false,0,true);
			file.addEventListener(Event.COMPLETE,onComplete,false,0,true);
			file.load();
			loadTxt.x = (stage.stageWidth-loadTxt.width)>>1;
			loadTxt.y = (stage.stageHeight-loadTxt.height)>>1;
			this.addChild(loadTxt);
		}
		
		protected function processHandler(event:ProgressEvent):void
		{
			percent = (Number(event.bytesLoaded/event.bytesTotal)*100).toFixed(1);
			info = "正在分析文件 . . ."+percent+"%";
		}
		
		protected function onComplete(event:Event):void
		{			
			trace("加载完成",file.extension,file.data.length);	
			info = "分析完毕，设置文件播放授权码。";
			setTimeout(typeCode,2000);
		}
		
		private function typeCode():void
		{
			this.removeChild(loadTxt);
			var author:AuthorCode = new AuthorCode();
			this.addChild(author);
			author.x = (stage.stageWidth - author.width)>>1;
			author.y = (stage.stageHeight - author.height)>>1;
			Utils.mediator.watch(Enum.SAVE_FILE,onSave);
		}
		
		private function get isMedia():Boolean
		{
			return file.extension=="mp4"||file.extension=="flv";
		}
		
		private function onSave(code:String=""):void
		{
			Utils.mediator.remove(Enum.SAVE_FILE,onSave);
			var data:ByteArray = new ByteArray();
			if(code.length==0)
			{
				data.writeShort(0);
			}else{
				var codeByte:ByteArray = new ByteArray();
				var encode:String = Base64.encode(code);
				trace("密钥:",encode);
				codeByte.writeMultiByte(encode,"gb2312");			
				data.writeShort(codeByte.length);
				data.writeBytes(codeByte);
			}
			data.writeBoolean(isMedia?true:false);
			data.writeBytes(file.data);
			
			saveData = new File();
			saveData.addEventListener(ProgressEvent.PROGRESS,saveProcess,false,0,true);
			saveData.addEventListener(Event.COMPLETE,encryFile,false,0,true);
			saveData.save(data,Enum.SAVE_FILE_NAME);
			file = null;
			this.removeChildren();
			this.addChild(loadTxt);
			info = "文件加密中";
		}
		
		protected function saveProcess(event:ProgressEvent):void
		{
			percent = (Number(event.bytesLoaded/event.bytesTotal)*100).toFixed(1);
			info = "保存加密文件 . . ."+percent+"%";
		}
		
		protected function encryFile(event:Event):void
		{
			saveData.removeEventListener(Event.COMPLETE,this.encryFile);
			this.removeChildren();
			this.addChild(new DoneEncry());
			saveData = null;
		}
		
		private function set info(value:String):void
		{
			loadTxt.text = value;
			loadTxt.x = (stage.stageWidth-loadTxt.width)>>1;
			loadTxt.y = (stage.stageHeight-loadTxt.height)>>1;
		}			
		
		protected function onAdded(event:Event):void
		{
			panel.viewPort(stage.stageWidth,stage.stageHeight);
			enBut.x = (panel.width-enBut.width)>>1;
			enBut.y = (panel.height-enBut.height)>>1;
			
			this.addChild(panel);
			
			panel.alpha = .5;
			panel.x = -panel.width;
			TweenMax.to(panel,.3,{alpha:1,x:0});
		}
	}
}