package com.idzeir.events
{
	import flash.events.Event;

	public class InfoEvent extends Event
	{
		/**
		 * 框架事件
		 */
		static public const SPREAD_INFO:String = "spreadInfo";
		/**
		 * 事件包含的数据
		 */
		private var _info:*;

		public function InfoEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_info = data;
		}

		override public function clone():Event
		{
			return new InfoEvent(type, _info, bubbles, cancelable);
		}

		public function get info():*
		{
			return _info;
		}

	}
}