/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	May 30, 2015 12:28:57 PM			
 * ===================================
 */

package com.idzeir.flashviewer.module.register
{
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.events.ViewEvent;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.HGroup;
	import com.idzeir.core.view.Label;
	import com.idzeir.core.view.Logger;
	import com.idzeir.core.view.VGroup;
	
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	
	public class RegisterModule extends Module
	{
		
		private var box:VGroup;
		public function RegisterModule()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			this.graphics.clear();
			this.graphics.beginFill(0x343434,.9);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.graphics.endFill();
			if(box)
			{
				box.x = stage.stageWidth - box.width >> 1;
				box.y = stage.stageHeight - box.height >> 1;
			}
		}
		
		/**
		 * 打开注册界面
		 */		
		public function openRegister():void
		{
			box = new VGroup();
			box.gap = 20;
			box.align = VGroup.CENTER;
			
			var tel:Label = new Label({label:"输入邮箱："});
			var telTxt:Label = new Label();
			telTxt.type = flash.text.TextFieldType.INPUT;
			telTxt.background = true;
			telTxt.background = 0xff0000;
			telTxt.textColor = 0x000000;
			telTxt.multiline = false;
			telTxt.wordWrap = false;
			telTxt.maxChars = 30;
			telTxt.width = 150;
			telTxt.height = 20;
			telTxt.restrict = "a-z|A-Z|0-9|@|.";
			
			var createReg:Button = new Button("生成",function():void
			{
				valid(telTxt.text);
			});
			
			var bottom:HGroup = new HGroup();
			bottom.gap = 10;
			bottom.valign = HGroup.MIDDLE;
			bottom.addChild(tel);
			bottom.addChild(telTxt);
			bottom.addChild(createReg);
			
			var top:Label = new Label();
			top.htmlText = "<font size = '30'>激活</font>";
			box.addChild(top);
			box.addChild(bottom);
			
			this.addChild(box);
			
			if(stage)
			{
				box.x = stage.stageWidth - box.width >> 1;
				box.y = stage.stageHeight - box.height >> 1;
			}
		}
		
		/**
		 * 验证输入邮箱格式
		 */		
		private function valid(value:String):void
		{
			var reg:RegExp =  /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
			if(reg.test(value))
			{
				dispatchEvent(new ViewEvent("create",value));
			}else{
				Logger.out("输入的邮箱格式不正确");
			}
		}
		
		/**
		 * 从界面中删除注册界面
		 */		
		public function removeFromParent():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
			this.graphics.clear();
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		/**
		 * 生成注册请求文件
		 */		
		public function waitCreateFile(value:String):void
		{
			box.removeChildren();
			var msg:Label = new Label();
			msg.maxWidth = 300;
			msg.htmlText = value;
			box.addChild(msg);
			if(stage)
			{
				box.x = stage.stageWidth - box.width >> 1;
				box.y = stage.stageHeight - box.height >> 1;
			}
		}
	}
}