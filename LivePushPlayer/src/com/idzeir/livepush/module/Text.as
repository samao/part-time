package com.idzeir.livepush.module
{	
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Label;
	
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 3, 2014 5:29:07 PM
	 *
	 **/
	
	public class Text extends Module
	{
		private var label:Label;
		
		public function Text()
		{
			super();
			label = new Label();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			label.width = stage.stageWidth;
			this.addChild(label);
		}
		
		public function set text(value:String):void
		{
			label.text = value;
		}
	}
}