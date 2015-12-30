package com.idzeir.flashviewer.module.fileGrid
{	
	import com.idzeir.core.bussies.Delegate;
	import com.idzeir.core.bussies.IModule;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 20, 2014 10:47:09 PM
	 *
	 **/
	
	public class FileGridDelegate extends Delegate
	{
		public function FileGridDelegate(_warp:String = "FileGridModule.swf")
		{
			super(_warp);			
		}
		
		override public function onloaded(_warp:IModule):void
		{
			super.onloaded(_warp);
			_e.watch(Enum.SHOW_FILES,function(value:*):void
			{
				excute(showFiles,value);
			});
			_e.watch(Enum.PREVIEW_FILE,function(value:*):void
			{
				excute(selected,value);
			});
			_e.watch(Enum.CLEAR_CURRENT_FILE_CARDS,function():void
			{
				excute(clearCards);
			});
		}
		
		private function clearCards():void
		{
			this._view.data = {"clearCards":null};
		}
		
		private function selected(url:String):void
		{
			this._view.apply("selected",url);
		}
		
		private function showFiles(files:*):void
		{
			this._view.data = {"showFiles":files};
		}		
	}
}