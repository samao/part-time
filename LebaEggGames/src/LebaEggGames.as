package
{
	import com.idzeir.leba.view.Games;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	[SWF(width="420",height="235",backgroundColor="#999999")]
	public class LebaEggGames extends Sprite
	{
		private var _c:IContext;
		
		public function LebaEggGames()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_c = new Context().install(MVCSBundle).configure(LebaEggGamesConfig,new ContextView(this));			
			this.addChild(new Games());
		}
	}
}