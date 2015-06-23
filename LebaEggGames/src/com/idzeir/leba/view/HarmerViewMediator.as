package com.idzeir.leba.view
{
	import com.idzeir.leba.event.FrameEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class HarmerViewMediator extends Mediator
	{
		[Inject]
		public var _view:HarmerView;
		
		public function HarmerViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			this.addContextListener(FrameEvent.HARMER_MOVE,function(e:FrameEvent):void
			{
				_view.move(e.info);
			});
			this.addContextListener(FrameEvent.HARMER_HIDEN,function(e:FrameEvent):void
			{
				_view.hiden();
			});
			this.addContextListener(FrameEvent.HARMER_PLAY,function(e:FrameEvent):void
			{
				_view.play();
				_view.index = e.info;
			});
			this.addViewListener("harmerFire",function():void
			{
				eventDispatcher.dispatchEvent(new FrameEvent(FrameEvent.HARMER_EVENT,_view.index));
			});
		}
	}
}