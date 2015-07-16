package com.idzeir.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class EventMap extends EventDispatcher
	{
		static private var _instance:EventMap;

		public function EventMap(target:IEventDispatcher = null)
		{
			super(target);
		}

		static public function map():EventMap
		{
			_instance ||= new EventMap();

			return _instance;
		}
	}
}