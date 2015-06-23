package com.idzeir.flashviewer.module.photo
{	
	import com.idzeir.core.bussies.Delegate;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.filesystem.File;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jul 5, 2014 5:17:19 PM
	 *
	 **/
	
	public class PhotoDelegate extends Delegate
	{
		public function PhotoDelegate(_warp:String="PhotoModule.swf")
		{
			super(_warp);
			_e.watch(Enum.PHOTO,function(file:File):void
			{
				excute(takePhoto,file);
			});
			
			_e.watch(Enum.NO_FOLDER_EXIST,function(value:*):void
			{
				excute(noFolderExist,value);
			});
		}
		
		private function noFolderExist(value:*):void
		{
			this._view.data= {"noFolderFound":[value]};
		}
		
		private function takePhoto(file:File):void
		{
			this._view.data = {takePhoto:[file]};
		}
	}
}