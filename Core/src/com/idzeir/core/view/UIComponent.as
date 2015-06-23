package com.idzeir.core.view
{
	import flash.display.DisplayObjectContainer;
	
	/** 
	 * 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午2:00:29
	 */
    internal class UIComponent extends BaseContainer
	{
		public function UIComponent(parent:DisplayObjectContainer=null)
		{
			super(parent);			
		}		
		/**
		 * 创建ui界面 
		 */	
		protected function addChildren():void
		{
			
		}
		
		override protected function onDrawRect():void
		{
			
		}
		
		override protected function onInit():void
		{
			this.addChildren();
			onResize();
		}
	}
}