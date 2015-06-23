package com.idzeir.core.utils
{	
	import com.idzeir.core.interfaces.IContext;
	import com.idzeir.core.interfaces.ITicker;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	/**
	 * 计时器
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Mar 10, 2014 10:04:49 PM
	 *
	 **/
	
	public class Ticker implements ITicker , IContext
	{
		/**
		 * 计时器掌控者 
		 */		
		private const hand:Sprite=new Sprite();
		/**
		 * 上一次执行计时器的时间 
		 */		
		private var lastTimestamps:uint=0;
		
		private var _dictionary:Dictionary=new Dictionary(true);
		/**
		 * 计时器暂停标记 
		 */		
		private var isPasue:Boolean=false;
		
		public function Ticker()
		{
		}
		
		public function startUp(value:*=null):void
		{
			
		}
		
		public function has(handler:Function):Boolean
		{
			for each(var i:Object in _dictionary)
			{
				if(i.hasOwnProperty("handler")&&i.handler == handler)
				{
					return true
				}
			}
			return false;
		}
		
		protected function update(event:Event):void
		{
			if(isPasue)return;
			var curTime:uint=getTimer();
			for each(var i:Object in _dictionary)
			{
				var total:uint = i.frame?1:(curTime-i.last)/i.delay;				
				while(total>0)
				{
					var handler:Function = i.handler;
					var pars:* = i.arg;
					i.last=curTime;
					handler.apply(null,pars?[pars]:null);
					if(++i.currentTimes>=i.totalTimes&&i.totalTimes!=0)
					{
						remove(i.handler);
					}
					total--;
				}
			}
		}
		
		public function call(delay:uint, handler:Function, times:uint=0, frame:Boolean = false, ...arg):void
		{
			_dictionary[handler] = {delay:delay,handler:handler,arg:arg,totalTimes:times, frame:frame, currentTimes:0, last:getTimer()};
		}
		
		public function remove(handler:Function):void
		{
			delete _dictionary[handler];
		}
		
		public function start():void
		{
			hand.addEventListener(Event.ENTER_FRAME,update);
			this.lastTimestamps = getTimer();
		}
		
		public function stop():void
		{
			hand.removeEventListener(Event.ENTER_FRAME,update);
		}
		
		public function pasue():void
		{
			this.isPasue=true;
		}
		
		public function resume():void
		{
			this.isPasue=false;
		}
	}
}