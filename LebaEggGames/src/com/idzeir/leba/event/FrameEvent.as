package com.idzeir.leba.event
{

	import flash.events.Event;

	public class FrameEvent extends Event
	{
		public static const CHANGE_BG_LAYER:String = "changeBgLayer";

		public static const HARMER_MOVE:String = "harmerMove";

		public static const HARMER_HIDEN:String = "harmerHiden";

		public static const HARMER_PLAY:String = "harmerPlay";

		public static const HARMER_EVENT:String = "harmerEvent";

		public static const SHOW_UNLUCKY:String = "showUnlucky";

		public static const RESET_GAME:String = "restGame";
		
		public static const SHOW_LUCKY:String = "showLucky";

		private var _info:*;

		public function FrameEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_info = data;
		}

		public function get info():*
		{
			return _info;
		}

		override public function clone():Event
		{
			return new FrameEvent(type, _info, bubbles, cancelable);
		}
	}
}
