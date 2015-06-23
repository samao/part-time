package com.idzeir.leba.view
{

	import com.idzeir.leba.event.FrameEvent;
	import com.idzeir.leba.vo.IStatus;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class GamesMediator extends Mediator
	{

		[Inject]
		public var _is:IStatus;

		public function GamesMediator()
		{
			super();
		}

		override public function initialize():void
		{
			super.initialize();
			this.addContextListener(FrameEvent.RESET_GAME, function():void
			{
				_is.toReady();
			});
		}
	}
}
