package com.idzeir.flashviewer.module.error
{	
	import com.idzeir.core.Context;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.context.IAlertMap;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 29, 2014 1:36:30 AM
	 *
	 **/
	
	public class ErrorModule extends Module
	{
		public function ErrorModule()
		{
			super();
			visible = false;
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000,.3);
			sp.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			sp.graphics.endFill();
			this.addChild(sp);
		}
		
		public function error(value:String):void
		{
			Logger.out(this,value);
			this.visible = true;
			
			var iAlert:IAlertMap = (Context.getContext("Alert") as IAlertMap);
			iAlert.stage = this;
			iAlert.alert(value,"<font color='#ffffff'>提示信息</font>");
		}
		
		public function allClear():void
		{
			this.visible = false;
		}
	}
}