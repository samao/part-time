package com.idzeir.leba.view
{
	import com.idzeir.leba.event.FrameEvent;
	import com.idzeir.leba.service.IService;
	import com.idzeir.leba.vo.IStatus;
	
	import flash.events.MouseEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class EggViewMediator extends Mediator
	{
		[Inject]
		public var _view:EggView;
		[Inject]
		public var _s:IService;
		[Inject]
		public var _is:IStatus;
		
		public function EggViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			this.addViewListener(MouseEvent.ROLL_OVER,viewHandler);
			this.addViewListener(MouseEvent.ROLL_OUT,viewHandler);
			this.addViewListener(MouseEvent.CLICK,viewHandler);
			this.addViewListener("showFeedBack",function():void
			{
				_s.getResult();
			});
			
			this.addContextListener(FrameEvent.HARMER_EVENT,function(e:FrameEvent):void
			{
				if(_view.index == e.info)
				{
					_view.play();
				}
				//_view.mouseEnabled = false;
			});
		}
		
		protected function viewHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.ROLL_OVER:
					if(_is.inReady)
					{
						this.eventDispatcher.dispatchEvent(new FrameEvent(FrameEvent.HARMER_MOVE,_view.stageTop));
					}
					break;
				case MouseEvent.ROLL_OUT:
					if(_is.inReady)
					{
						this.eventDispatcher.dispatchEvent(new FrameEvent(FrameEvent.HARMER_HIDEN));
					}
					break;
				case MouseEvent.CLICK:
					_is.toPlaying();
					_view.mouseEnabled = false;
					this.eventDispatcher.dispatchEvent(new FrameEvent(FrameEvent.HARMER_PLAY,_view.index));
					break;
			}
		}
	}
}