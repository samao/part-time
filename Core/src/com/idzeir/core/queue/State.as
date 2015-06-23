package com.idzeir.core.queue
{	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 * 状态
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Sep 2, 2014 3:00:44 PM
	 *
	 **/
	
	public class State extends EventDispatcher implements IState
	{
		/**
		 * 管理中心
		 */
		protected var _owner:IMachine;
		
		public function State(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function added():void
		{
		}
		
		public function removed():void
		{
		}
		
		public function enter():void
		{
		}
		
		public function exit():void
		{
		}
		
		public function complete():void
		{
			if(_owner)
			{
				_owner.remove(this);
			}
		}
		
		public function willInterupt():Boolean
		{
			return false;
		}
		
		public function set owner(value:IMachine):void
		{
			_owner = value;
		}
	}
}