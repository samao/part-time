package
{

	import com.idzeir.leba.command.EggGamesCommand;
	import com.idzeir.leba.event.FrameEvent;
	import com.idzeir.leba.service.IService;
	import com.idzeir.leba.service.Service;
	import com.idzeir.leba.view.BgLayerView;
	import com.idzeir.leba.view.BgLayerViewMediator;
	import com.idzeir.leba.view.EggView;
	import com.idzeir.leba.view.EggViewMediator;
	import com.idzeir.leba.view.Games;
	import com.idzeir.leba.view.GamesMediator;
	import com.idzeir.leba.view.HarmerView;
	import com.idzeir.leba.view.HarmerViewMediator;
	import com.idzeir.leba.view.LuckResultView;
	import com.idzeir.leba.view.LuckResultViewMediator;
	import com.idzeir.leba.view.PopUpView;
	import com.idzeir.leba.view.PopUpViewMediator;
	import com.idzeir.leba.vo.GameStatusVo;
	import com.idzeir.leba.vo.IStatus;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	public class LebaEggGamesConfig implements IConfig
	{

		[Inject]
		public var _m:IMediatorMap;

		[Inject]
		public var _c:IEventCommandMap;

		[Inject]
		public var _i:IInjector;

		public function LebaEggGamesConfig()
		{
		}

		public function configure():void
		{
			_m.map(BgLayerView).toMediator(BgLayerViewMediator);
			_m.map(EggView).toMediator(EggViewMediator);
			_m.map(HarmerView).toMediator(HarmerViewMediator);
			_m.map(PopUpView).toMediator(PopUpViewMediator);
			_m.map(Games).toMediator(GamesMediator);
			_m.map(LuckResultView).toMediator(LuckResultViewMediator);

			_c.map(FrameEvent.CHANGE_BG_LAYER, FrameEvent).toCommand(EggGamesCommand);

			_i.map(IService).toSingleton(Service);
			_i.map(IStatus).toSingleton(GameStatusVo);
		}
	}
}
