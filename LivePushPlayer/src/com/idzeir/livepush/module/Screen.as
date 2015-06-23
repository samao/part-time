package com.idzeir.livepush.module
{	
	import com.idzeir.core.bussies.Module;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 2, 2014 1:12:02 PM
	 *
	 **/
	
	public class Screen extends Module
	{
		private var box:Sprite;
		private var _type:String;
		
		public function Screen()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			box = new Sprite();
			this.addChild(box);
		}
		
		/** 
		 * 切换模块
		 */
		public function switchView(value:String):void
		{
			if(value==_type)
			{
				return;
			}
			_type = value;
			box.removeChildren()
			box.addChild(ModuleControler.getControler().module(value) as Module);
		}
	}
}