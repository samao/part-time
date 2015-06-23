package com.idzeir.core.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class Mediator implements IMediator
	{
		private var _dictionary:Dictionary = new Dictionary(true);
		
		private var _eventDispather:EventDispatcher;
		
		public function Mediator()
		{
		}
		
		public function watch(type:String,handler:Function,host:* = null):void
		{
			if(!has(type))
			{
				this._dictionary[type] = [];
			}
			var typed:Array = this._dictionary[type];
			typed.push({"handler":handler,"host":host});
		}
		
		private function has(type:String):Boolean
		{
			if(this._dictionary.hasOwnProperty(type))
			{
				return true;
			}
			return false;
		}
		
		public function send(type:String,host:* = null):void
		{
			if(has(type))
			{
				var typed:Array = this._dictionary[type];
				typed.forEach(function(e:Object,index:int,arr:Array):void
				{
					var handler:Function = e["handler"];
					if(!this._eventDispather)
					{
						_eventDispather = new EventDispatcher();
						_eventDispather.addEventListener(ApplyEvent.APPLY_METHOD,applyHandler);
					}
					var info:Object = {"handler":handler,"tar":e["host"]?e["host"]:null,"arg":host?[host]:null}
					_eventDispather.dispatchEvent(new ApplyEvent(ApplyEvent.APPLY_METHOD,info));
					//handler.apply(e["host"]?e["host"]:null,host?[host]:null);
				});
				return;
			}
			trace("不存在事件watcher:",type);
		}
		
		protected function applyHandler(event:ApplyEvent):void
		{
			var handler:Function = event.info["handler"];
			var tar:* = event.info["tar"];
			var arg:* = event.info["arg"];
			
			handler&&handler.apply(tar,arg);
		}
		
		public function remove(type:String,handler:Function):void
		{
			if(has(type))
			{
				var typed:Array = this._dictionary[type];
				for(var i:uint = 0;i<typed.length;i++)
				{
					if(typed[i]["handler"] == handler)
					{
						typed.splice(i,1);
						break;
					}
				}
				if(typed.length==0)
				{
					delete this._dictionary[type];
				}
				return;
			}
			trace("不存在事件watcher:",type);
		}
	}
}