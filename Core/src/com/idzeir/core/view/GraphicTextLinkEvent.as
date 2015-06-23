package com.idzeir.core.view
{
	import flash.events.Event;
	
	public class GraphicTextLinkEvent extends Event
	{
		/**
		 * 图文混排点击
		 */
		static public const TEXT_LINK:String = "textLink";
		/**
		 * 图文混排userData.event的数据
		 */
		public var info:*;
		
		public function GraphicTextLinkEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			info = data;
		}
		
		override public function clone():Event
		{
			return new GraphicTextLinkEvent(type,info,this.bubbles,this.cancelable);
		}
	}
}