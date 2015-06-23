/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	May 26, 2015 11:35:47 AM			
 * ===================================
 */

package
{
	import com.hurlant.util.Base64;
	import com.idzeir.core.view.BaseStage;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.Label;
	import com.idzeir.core.view.Logger;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	/**
	 * 软件注册机
	 */	
	[SWF(width = 200,height=300,backgroundColor="#ffffff"]
	public class FlashRegister extends BaseStage
	{
		private const VERSION:String = "1.0.1";
			
		private var _title:Label;
		private var msg:TextField;
		
		override protected function init(e:Event=null):void
		{
			super.init(e);
			
			_title ||= new Label();
			_title.maxWidth = 200;
			_title.autoSize = "left";
			_title.htmlText = "<font size='24' color='#fff0000'><b>软件注册 </b></font><font size='9' color='#fff0000'>Beta</font>";
			_title.x = stage.stageWidth - _title.width>>1;
			_title.y = 5;
			this.addChild(_title);
			
			const GAP:uint = 100;
			const NORMAL:String = "拖入注册文件";
			var box:Sprite = new Sprite();
			
			var label:Label = new Label({label:NORMAL})
			label.textColor = 0x00FF00;
			label.multiline = true;
			label.maxWidth = 300;
			label.x = label.y = GAP/2;
			box.addChild(label);
			box.graphics.beginFill(0x343434,.7);
			box.graphics.lineStyle(1,0x000000);
			box.graphics.drawRect(0,0,label.width + GAP,label.height + GAP);
			box.graphics.endFill();
			this.addChild(box);
			
			box.x = stage.stageWidth - box.width>>1;
			box.y = _title.y +_title.height + 5;
			
			var URL:String = "";
			var REGISTER_CONTEXT:String = "";
			
			box.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,function(ne:NativeDragEvent):void
			{
				NativeDragManager.dropAction = NativeDragActions.MOVE; 
				NativeDragManager.acceptDragDrop(box);
			});
			
			box.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,function(ne:NativeDragEvent):void
			{
				var byte:Object = ne.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
				if(byte&&byte["length"] == 1)
				{
					var file:File = byte[0];
					URL = file.url;
					label.text = "分析注册文件";
					label.x = box.width - label.width>>1;
					label.y = box.height - label.height>>1;
					file.addEventListener(Event.COMPLETE,function():void
					{
						var s:String = file.data.readUTFBytes(file.data.bytesAvailable);
						
						var deStr:String = Base64.decode(s);
						if(deStr.indexOf(RegInfo._FORMAT_) > 0)
						{
							REGISTER_CONTEXT = deStr;
							button.visible = true;
							setInfo(deStr);
						}else{
							_sText.text = "错误文件";
							_sText.x = stage.stageWidth - _sText.width >> 1;
							_sText.y = button.y - _sText.height - 5;
							setTimeout(function():void
							{
								_sText.text = "";
							},1500);
						}
					});
					file.load();
				}
			});
			
			var button:Button = new Button("<font color='#ffffff'>生产</font>",function():void
			{
				_sText.text = "生成成功!";
				_sText.x = stage.stageWidth - _sText.width >> 1;
				_sText.y = button.y - _sText.height - 5;
				
				button.visible = false;
				
				var regFile:File = new File(URL.replace(".req",".res"));
				var fs:FileStream = new FileStream();
				fs.open(regFile,FileMode.WRITE);
				fs.writeUTFBytes(RegInfo.createInstance(REGISTER_CONTEXT).key);
				fs.close();
				REGISTER_CONTEXT = URL = "";
				label.text = NORMAL;
				setTimeout(function():void
				{
					_sText.text = "";
				},1500);
			});
			
			//trace("HAUD^^DAKKCA129#register$qiyanlong@wozine.com");
			createInfoMsg(5,box.y+box.height+5);
			
			var buttonLayer:Shape = new Shape();
			buttonLayer.graphics.beginFill(0x343434,1);
			buttonLayer.graphics.drawRect(0,0,button.width,button.height);
			buttonLayer.graphics.endFill();
			button.bglayer = buttonLayer;
			
			button.visible = false;
			this.addChild(button);
			button.x = stage.stageWidth - button.width>>1;
			button.y = stage.stageHeight - button.height - 10;
			
			
			var _sText:TextField = new TextField();
			_sText.antiAliasType = AntiAliasType.ADVANCED;
			_sText.defaultTextFormat = new TextFormat(null,null,null,true);
			_sText.autoSize = "left";
			_sText.textColor = 0xff0000;
			_sText.text = "";
			_sText.x = stage.stageWidth - _sText.width >> 1;
			_sText.y = button.y - _sText.height - 2;
			this.addChild(_sText);
			
			this.setDebugPort(stage.stageWidth,stage.stageHeight);
			logInfo();
		}
		
		private function createInfoMsg(xPos:int,yPos:int):void
		{
			msg = new TextField();
			msg.antiAliasType = AntiAliasType.ADVANCED;
			msg.defaultTextFormat = new TextFormat(null,null,null,true);
			msg.defaultTextFormat.leading = 5;
			msg.autoSize = "left";
			msg.y = yPos;
			this.addChild(msg);
		}

		private function setInfo(info:String):void
		{
			var cpu:String = "";
			var mail:String = "";
			var time:String = "";
			
			var infoArr:Array = info.split(RegInfo._FORMAT_);
			cpu = infoArr.length > 0 ? infoArr[0] : "";
			mail = infoArr.length > 1 ? infoArr[1] : "";
			time = infoArr.length > 2 ? infoArr[2] : "";
			
			msg.text = RegInfo.createInstance(info).toString();
			msg.background = true;
			msg.backgroundColor = 0xcdcdcd;
			msg.x = stage.stageWidth - msg.width>>1;
			Logger.unTimeLog(RegInfo.createInstance(info).toString().replace(/=/ig,""));
		}
		
		private function logInfo():void
		{
			Logger.unTimeLog("==============================");
			Logger.unTimeLog("素材浏览软件注册机");
			Logger.unTimeLog("Version:beta "+VERSION);
			Logger.unTimeLog("Author:"+"<a href='http://t.qq.com/idzeir'><font color='#ff0000'>iDzeir</font></a>");
			Logger.unTimeLog("E-mail: qiyanlong@wozine.com");
			Logger.unTimeLog("System:"+flash.system.Capabilities.os);
			Logger.unTimeLog("==============================");
		}
	}
}
import com.hurlant.util.Base64;

class RegInfo extends Object
{
	public static const _FORMAT_:String = "#register$";
	private static const SECRET_KEY:String = "iDzEirLonGLoNg";
	private static var _instance:RegInfo;
	
	private var _time:String,_hardware:String,_mail:String;
	
	public function RegInfo()
	{
		if(_instance)
			throw new Error("不能new");
	}
	
	public static function createInstance(value:String):RegInfo
	{
		_instance ||= new RegInfo();
		_instance.updateFromInfo(value);
		return _instance;
	}
	
	private function updateFromInfo(info:String):void
	{
		var infoArr:Array = info.split(RegInfo._FORMAT_);
		_hardware = infoArr.length > 0 ? infoArr[0] : "";
		_mail = infoArr.length > 1 ? infoArr[1] : "";
		_time = infoArr.length > 2 ? infoArr[2] : "";
	}
	
	public function toString():String
	{
		var s:String = "============================\n注册文件信息：\n\t硬件号:"+_hardware+"\n\t邮箱:"+_mail+(_time!=""?"\n\tTime:"+_time:"")+"\n============================"
		return s;
	}
	
	/**
	 * 注册关联信息
	 */	
	private function get info():String
	{
		return Base64.encode(_hardware+_FORMAT_+_mail);
	}
	/**
	 * 生成的注册信息
	 */	
	public function get key():String
	{
		var source:String = _hardware+SECRET_KEY+_FORMAT_+_mail+_FORMAT_+new Date().time;
		//trace(source);
		return Base64.encode(source);
	}
}