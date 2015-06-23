package com.idzeir.flashviewer.module.error
{	
	import com.idzeir.core.bussies.Delegate;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 29, 2014 1:36:53 AM
	 *
	 **/
	
	public class ErrorDelegate extends Delegate
	{
		public function ErrorDelegate(_warp:String="ErrorModule.swf")
		{
			super(_warp);
			_e.watch(Enum.ERROR_INFO,function(url:String):void
			{
				excute(error,url);
			});
			_e.watch(Enum.ERROR_ALL_CLEAR,function(value:*=null):void
			{
				excute(allClear);
			});
		}
		
		private function allClear():void
		{
			this._view.apply("allClear");
		}
		
		private function error(value:String):void
		{
			this._view.data = {error:[value]};
		}
	}
}