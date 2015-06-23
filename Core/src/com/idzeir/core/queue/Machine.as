package com.idzeir.core.queue
{	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 * 状态机
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Sep 2, 2014 3:03:24 PM
	 **/
	
	public class Machine extends EventDispatcher implements IMachine
	{
		protected var _states:Vector.<IState>;
		
		public function Machine(target:IEventDispatcher=null)
		{
			super(target);
			_states = new Vector.<IState>();
		}
		
		public function add(_state:IState, isQueue:Boolean=true):void
		{
			_state.owner = this;
			_state.added();
			if(isQueue)
			{
				_states.push(_state);
				if(current == _state)
				{
					_state.enter();
				}
			}else{
				if(_state.willInterupt())
				{
					if(current != null)
					{
						remove(_state);
					}
					_states.unshift(_state);
					_state.enter();
				}else{
					if(_states.length > 0)
					{
						_states.splice(0,0,_state);
					}else{
						_states.unshift(_state);
						_state.enter();
					}
				}
			}
			notify(MachineEvent.ADDED, _state);
		}
		
		public function remove(_state:IState):void
		{
			_state.exit();
			var index:int = _states.indexOf(_state);
			if(index > -1)
			{
				_states.splice(index, 1);
				_state.removed();
				
				notify(MachineEvent.REMOVED, _state);
				if(current)
				{
					current.enter();
				}else{
					notify(MachineEvent.COMPLETED);
				}
			}
		}
		
		public function insert(base:IState, target:IState,isLeft:Boolean = false):void
		{
			var index:int = _states.indexOf(base);
			if (index > -1) 
			{
				target.owner = this;
				if (!isLeft) {
					index += 1;
				}
				target.added();
				_states.splice(index, 0, target);
				
				notify(MachineEvent.INSERTED, target, index);
				
				if (current == target) {
					target.enter();
				}
			}
		}
		
		public function pop():void
		{
			if (_states && _states.length > 0) {
				var state:IState = _states.shift();
				state.exit();
				state.removed();
				if (current) {
					current.enter();
				} else {
					notify(MachineEvent.COMPLETED);
				}
			}
		}
		
		public function get current():IState
		{
			if (_states && _states.length > 0) {
				return _states[0];
			}
			return null;
		}
		
		public function cleanUp():void
		{
			while (current != null) {
				current.exit();
				current.removed();
				_states.shift();
			}
			_states.length = 0;
		}
		
		protected function notify(type:String, state:IState = null, index:int = -1):void {
			var e:MachineEvent = new MachineEvent(type);
			e.state = state;
			e.index = index;
			dispatchEvent(e);
		}
	}
}