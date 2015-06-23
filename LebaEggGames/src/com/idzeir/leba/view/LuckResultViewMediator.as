package com.idzeir.leba.view
{
	import com.idzeir.leba.event.FrameEvent;
	import com.idzeir.leba.service.IService;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class LuckResultViewMediator extends Mediator
	{
		[Inject]
		public var _view:LuckResultView;
		
		[Inject]
		public var _s:IService;
		
		public function LuckResultViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			this.addContextListener(FrameEvent.SHOW_LUCKY,function(e:FrameEvent):void
			{
				_view.url = e.info;
			});
			
			this.addViewListener("resetGame",function():void
			{
				eventDispatcher.dispatchEvent(new FrameEvent(FrameEvent.RESET_GAME));
			});
			this.addViewListener("IOError",function():void
			{
				_s.onErrorMsg("加载中奖图片失败");
			});
		}
	}
}