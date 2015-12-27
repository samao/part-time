/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	Dec 26, 2015 3:00:03 PM			
 * ===================================
 */

package com.idzeir.flashviewer.module.guide
{
	import com.idzeir.core.bussies.Delegate;
	import com.idzeir.core.bussies.IModule;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	public class GuideDelegate extends Delegate
	{
		private var _ENTER_:Boolean = false;
		
		private var _INITING_:Boolean = false;
		
		public function GuideDelegate(_warp:String="GuideModule.swf")
		{
			super(_warp);
			
			this._e.watch(Enum.READY_INIT,function():void
			{
				_ENTER_ = true;
				if(_view)
				{
					_view.data = {"enter":null};
				}
			});
			this._e.watch(Enum.SUCCESS_REGISTER,function():void
			{
				_INITING_ = true;
				_view&&(_view.data = {"initing":null});
			});
		}
		
		override public function onloaded(_warp:IModule):void
		{
			super.onloaded(_warp);
			
			if(_ENTER_)
			{
				_view.data = {"enter":null};
			}
			
			_INITING_&&(_view.data = {"initing":null});
		}
	}
}