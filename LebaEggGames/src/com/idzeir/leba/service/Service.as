package com.idzeir.leba.service
{

	import com.idzeir.leba.event.FrameEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;

	public class Service extends EventDispatcher implements IService
	{
		private const SET_BGROUND:String = "setBglayer";

		private const EGG_READY:String = "eggReady";

		private const PLAY_EGG:String = "playEgg";
		
		private const IOError:String = "alert";
		
		private const SHOW_UNLUCKY:String = "showUnlucky";
		
		private const SHOW_LUCKY:String = "showLucky";
		
		[Inject]
		public var _e:IEventDispatcher;

		public function Service(target:IEventDispatcher = null)
		{
			super(target);

			addExternal();
		}

		private function addExternal():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback(SET_BGROUND, setBglayer);
				ExternalInterface.addCallback(SHOW_UNLUCKY,showUnlucky);
				ExternalInterface.addCallback(SHOW_LUCKY,showLucky);
				ExternalInterface.call(EGG_READY);
			}
		}
		
		public function onErrorMsg(value:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(IOError,value);
			}
		}

		public function setBglayer(value:String):void
		{
			_e.dispatchEvent(new FrameEvent(FrameEvent.CHANGE_BG_LAYER, value));
		}

		public function showUnlucky(value:String):void
		{
			_e.dispatchEvent(new FrameEvent(FrameEvent.SHOW_UNLUCKY, value));
		}
		
		public function showLucky(value:String):void
		{
			_e.dispatchEvent(new FrameEvent(FrameEvent.SHOW_LUCKY, "1.png"));
		}

		public function getResult():void
		{
			var s:String;
			if (ExternalInterface.available)
			{
				s = ExternalInterface.call(PLAY_EGG);
			}
			else
			{
				if(Math.random()>.5)
				{
					showUnlucky("对不起没有中奖！");
				}else{
					showLucky("")
				}
			}
			//feedback(s);
		}
	}
}
