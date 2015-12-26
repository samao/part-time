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
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Logger;
	
	import flash.events.Event;
	
	public class GuideModule extends Module
	{
		public function GuideModule()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000,.8);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.graphics.endFill();
			
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
	}
}