/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	May 30, 2015 2:33:34 PM			
 * ===================================
 */

package com.idzeir.core.events
{
	import flash.events.Event;
	
	
	public class ViewEvent extends Event
	{
		private var _info:* = null;
		
		public function ViewEvent(type:String,data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_info = data;
		}
		
		public function get info():*
		{
			return _info;
		}
	}
}