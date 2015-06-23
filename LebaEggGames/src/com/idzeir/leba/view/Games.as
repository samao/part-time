package com.idzeir.leba.view
{

	import flash.display.Sprite;
	import flash.events.Event;

	public class Games extends Sprite
	{
		private var _bglayer:BgLayerView;

		private var _eggs:Sprite;

		private var _harmer:HarmerView;

		private var _popAnswer:PopUpView;
		
		private var _luckResult:LuckResultView;

		public function Games()
		{
			this.mouseEnabled = false;
			if (!stage)
				this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			else
				onAdded();
		}

		protected function onAdded(event:Event = null):void
		{
			_bglayer ||= new BgLayerView();
			_eggs ||= new Sprite();
			_harmer ||= new HarmerView();
			_popAnswer ||= new PopUpView();
			_luckResult ||= new LuckResultView();

			this.addChild(_bglayer);
			this.addChild(_eggs);
			this.addChild(_harmer);
			this.addChild(_popAnswer);
			this.addChild(_luckResult);
			
			setupUI();
		}

		private function setupUI():void
		{
			const TOTAL:uint = 3;
			for (var i:uint = 0; i < TOTAL; ++i)
			{
				var eg:EggView = new EggView(i);
				eg.x = (eg.width + 30) * i;
				_eggs.addChild(eg);
			}

			_eggs.x = stage.stageWidth - _eggs.width >> 1;
			_eggs.y = (stage.stageHeight - _eggs.height >> 1) + 40;
		}
	}
}
