package com.idzeir.flashviewer.module.preview
{	
	import com.idzeir.core.bussies.Delegate;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 20, 2014 10:44:32 PM
	 *
	 **/
	
	public class PreViewDelegate extends Delegate
	{
		
		public function PreViewDelegate(_warp:String = "PreViewModule.swf")
		{
			super(_warp);
			_e.watch(Enum.PREVIEW_FILE,function(url:String):void
			{
				excute(play,url);
			});
		}
		
		private function play(url:String):void
		{
			_view.data={"play":[url]};
		}
	}
}