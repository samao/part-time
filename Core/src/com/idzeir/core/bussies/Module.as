package com.idzeir.core.bussies
{
	import com.idzeir.core.events.IMediator;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * 模块基类
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 19, 2014 10:45:44 PM
	 *
	 **/

	public class Module extends Sprite implements IModule
	{
		protected var _e:IMediator;
		protected var _name:String;

		public function Module()
		{
			super();
			_e = Utils.mediator;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		protected function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		protected function onRemove(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function apply(method:String,...arg):*
		{
			var callFun:Function = this[method];
			if(callFun!=null)
			{
				return callFun.apply(this,arg);
			}
			return null;
		}

		public function set data(value:*):void
		{
			for (var i:String in value)
			{
				if (this.hasOwnProperty(i))
				{
					if (this[i] is Function)
					{
						//调用的是方法
						var handle:Function = this[i] as Function;
						var pars:* = value[i];
						if (pars)
						{
							if (pars is Array)
							{
								if (pars.length > 1)
								{
									handle.apply(null, pars);
								}
								else
								{
									//单独传一个数组时候用[]括号包起来
									handle.apply(null, [pars[0]]);
								}
							}
							else
							{
								handle.apply(null, pars);
							}
						}
						else
						{
							handle.apply();
						}
					}
					else
					{
						//调用的是public的属性
						this[i] = value[i];
					}
				}
			}
		}
		
		override public function set name(value:String):void
		{
			_name = value;
		}
		override public function get name():String
		{
			return _name;
		}
		
		public function onload():void
		{
		}
	}
}