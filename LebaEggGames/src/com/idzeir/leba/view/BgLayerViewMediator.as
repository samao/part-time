package com.idzeir.leba.view
{
	import com.idzeir.leba.event.FrameEvent;
	import com.idzeir.leba.service.IService;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class BgLayerViewMediator extends Mediator
	{
		[Inject]
		public var _view:BgLayerView;
		
		[Inject]
		public var _s:IService;
		
		public function BgLayerViewMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			this.addContextListener(FrameEvent.CHANGE_BG_LAYER,function(e:FrameEvent):void
			{
				_view.url = e.info;
			});
			
			this.addViewListener("IOError",function():void
			{
				_s.onErrorMsg("加载背景失败");
			});
		}
	}
}