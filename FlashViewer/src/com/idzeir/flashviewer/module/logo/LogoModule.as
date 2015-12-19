package com.idzeir.flashviewer.module.logo
{	
	import com.idzeir.assets.InnerLogoSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Logger;
	
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 4:43:36 PM
	 *
	 **/
	
	public class LogoModule extends Module
	{
		public function LogoModule()
		{
			super();
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			createLogo();
			this.x = 20;
			this.y = 30;
		}
		
		private function createLogo():void
		{
			this.addChild(new InnerLogoSP());
		}
	}
}