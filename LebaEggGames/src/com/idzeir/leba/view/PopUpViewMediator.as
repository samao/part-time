package com.idzeir.leba.view
{

	import com.idzeir.leba.event.FrameEvent;

	import flash.events.Event;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class PopUpViewMediator extends Mediator
	{

		[Inject]
		public var _view:PopUpView;

		public function PopUpViewMediator()
		{
			super();
		}

		override public function initialize():void
		{
			super.initialize();
			this.addContextListener(FrameEvent.SHOW_UNLUCKY, function(e:FrameEvent):void
			{
				_view.show(e.info);
			});

			this.addViewListener("resetGame", function(e:Event):void
			{
				eventDispatcher.dispatchEvent(new FrameEvent(FrameEvent.RESET_GAME));
			});
		}
	}
}
