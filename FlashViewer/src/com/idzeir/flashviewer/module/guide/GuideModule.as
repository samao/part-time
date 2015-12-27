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
	import com.idzeir.assets.HellpRegister;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
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
		
		private var _point:Point = new Point(690,255);
		
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
			
			this.addChild(but);
			
			innerBut = new Button("帮\n助",openHelp);
			innerBut.bgColor = 0xae895d;
			innerBut.visible = false;
			innerBut.x = stage.stageWidth - innerBut.width;
			this.addChild(innerBut);
			
			_e.watch(Enum.CREATE_REQ,function():void
			{
				but.visible = false;
			});
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
			_point.x = 815;
			_point.y = 85;
			if(but)
			{
				but.x = 815;
				but.y = 85;
			}
		}
		
		private function openHelp(e:MouseEvent):void
		{
			this.graphics.clear();
			if(!_OPEN_)
			{
				this.graphics.beginFill(0x000000,.8);
				this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				this.graphics.endFill();
				but.visible = false;
				innerBut.visible = true;
			}
			_OPEN_ = !_OPEN_;
			_pages ||= new HelpPages();
			this.addChildAt(_pages,0);
			_pages.visible = _OPEN_;
			if(!_OPEN_)
			{
				innerBut.visible = false;
				_ENTER_?innerBut.visible = true:but.visible = true;
			}
			innerBut.label = _OPEN_?"关\n闭":"帮\n助";
		}
	}
}