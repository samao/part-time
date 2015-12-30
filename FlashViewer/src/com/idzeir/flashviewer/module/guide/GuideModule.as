/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Dec 26, 2015 2:59:20 PM			
 * ===================================
 */

package com.idzeir.flashviewer.module.guide
{
	import com.idzeir.assets.FullScreenSP;
	import com.idzeir.assets.HellpRegister;
	import com.idzeir.assets.HelpCloseSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class GuideModule extends Module
	{

		private var but:Button;
		
		private var _OPEN_:Boolean = false;
		
		private var _pages:HelpPages;

		private var innerBut:Button;
		
		private var _ENTER_:Boolean = false;
		
		private var _INITING_:Boolean = true;
		
		private var _point:Point = new Point(690,255);

		private var bgLayer:Sprite;

		private var closeBut:Button;
		
		public function GuideModule()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			but = new Button("",openHelp);
			
			but.bglayer = new HellpRegister();
			but.x = _point.x;
			but.y = _point.y;
			but.scaleX = but.scaleY = 1.5;
			but.visible = _INITING_;
			
			this.addChild(but);
			
			innerBut = new Button("<font size='12'>帮\n助</font>",openHelp);
			innerBut.bgColor = 0xae895d;
			var innerBgLayer:Sprite = new FullScreenSP();
			innerBut.bglayer = innerBgLayer;
			innerBut.over = true;
			innerBut.visible = false;
			innerBgLayer.width = 22;
			innerBgLayer.height = 40;
			innerBut.label = "<font size='12'>帮\n助</font>";
			innerBut.x = stage.stageWidth - 22;
			this.addChild(innerBut);
			
			_e.watch(Enum.CREATE_REQ,function():void
			{
				but.visible = false;
			});
			
			_pages ||= new HelpPages();
			_pages.visible = false;
			this.addChildAt(_pages,0);
			
			bgLayer = new Sprite();
			bgLayer.visible = false;
			bgLayer.graphics.beginFill(0x000000,0);
			bgLayer.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			bgLayer.graphics.beginFill(0x000000,.8);
			bgLayer.graphics.drawRect(stage.stageWidth-875>>1,0,875,stage.stageHeight);
			bgLayer.graphics.endFill();
			
			_pages.x = (stage.stageWidth-875>>1)+37.5;
			_pages.y = stage.stageHeight - 450>>1;
			
			bgLayer.addEventListener(MouseEvent.CLICK,function(evt:Event):void
			{
				evt.stopImmediatePropagation();
				evt.stopPropagation();
			});
			
			this.addChildAt(bgLayer,0);
			
			closeBut = new Button("",openHelp);
			closeBut.bglayer = new HelpCloseSP();
			closeBut.visible = false;
			
			closeBut.x = (stage.stageWidth-875>>1) + 875 - closeBut.width - 3;
			closeBut.y = 3;
			
			this.addChild(closeBut);
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
		
		public function enter():void
		{
			but.visible = false;
			innerBut.visible = true;
			_ENTER_ = true;
		}
		
		public function initing():void
		{
			_INITING_ = false;
			_point.x = 815;
			_point.y = 85;
			if(but)
			{
				but.visible = false;
				but.x = _point.x;
				but.y = _point.y;
			}
		}
		
		private function openHelp(e:MouseEvent):void
		{
			if(!_OPEN_)
			{
				but.visible = false;
				innerBut.visible = true;
				//closeBut.x = (stage.stageWidth-875>>1) + 875 - closeBut.width - 3;
				//closeBut.y = 3;
			}
			_OPEN_ = !_OPEN_;
			bgLayer.visible = _OPEN_;
			closeBut.visible = _OPEN_;
			innerBut.visible = !_OPEN_;
			_pages.visible = _OPEN_;
			if(!_OPEN_)
			{
				innerBut.visible = false;
				_ENTER_?innerBut.visible = true:but.visible = true;
			}
			//innerBut.label = _OPEN_?"关\n闭":"帮\n助";
		}
	}
}