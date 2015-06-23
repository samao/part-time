package com.idzeir.core.queue
{	
	import flash.events.Event;
	
	
	/**
	 * 状态机事件
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Sep 2, 2014 3:16:57 PM
	 *
	 **/
	
	public class MachineEvent extends Event
	{
		public static const ADDED:String = "added";
		public static const REMOVED:String = "removed";
		public static const INSERTED:String = "inserted";
		public static const COMPLETED:String = "completed";
		
		public var state:IState;
		public var index:int;
		
		public function MachineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}