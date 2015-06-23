package com.idzeir.core.events
{
	import flash.events.Event;
	
	internal class ApplyEvent extends Event
	{
		static public const APPLY_METHOD:String = "applyMethod";
		
		private var _info:* = null;
		
		public function ApplyEvent(type:String,data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
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