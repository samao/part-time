package com.idzeir.leba.view
{

	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Strong;
	import com.idzeir.source.PopupPanel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PopUpView extends Sprite
	{
		public const DEF:String = "default";

		private var _pop:PopupPanel;

		private var _info:TextField;

		private var close:MovieClip;

		public function PopUpView()
		{
			super();
			_pop = new PopupPanel();
			this.addChild(_pop);

			_info = new TextField();
			_info.mouseEnabled = false;
			_info.autoSize = TextFieldAutoSize.CENTER;
			_info.defaultTextFormat = new TextFormat("Microsoft YaHei,微软雅黑,宋体", 12, 0xff0000, true);
			_info.filters = [new GlowFilter(0xffffff, 1, 1, 1, 1), new BlurFilter(1, 1, 1)]
			_info.width = _pop.width;
			_info.height = 20;
			_pop.addChild(_info);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		protected function onAdded(event:Event):void
		{
			close = _pop["okButton"];
			close.buttonMode = true;
			x = stage.stageWidth >> 1;
			y = stage.stageHeight >> 1;
			close.addEventListener(MouseEvent.CLICK, onCloseClik);
			close.addEventListener(MouseEvent.ROLL_OVER, onOverHandler);
			close.addEventListener(MouseEvent.ROLL_OUT, onOverHandler);
			scaleX = scaleY = .5;
			alpha = 0;

			dispose();
			//show("奖励你个宝马250");
		}

		protected function onOverHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.ROLL_OVER:
					close.gotoAndStop("over");
					break;
				case MouseEvent.ROLL_OUT:
					close.gotoAndStop(1);
					break;
			}
		}

		protected function onCloseClik(event:MouseEvent):void
		{
			this.dispatchEvent(new Event("resetGame"));
			TweenMax.to(this, .3, {scaleX: .8, scaleY: .8, alpha: 0, onComplete: dispose,ease:com.greensock.easing.Strong.easeInOut})
		}

		private function onAppear():void
		{

		}

		public function show(value:String = DEF):void
		{
			this.visible = true;
			_info.htmlText = value;
			_info.x = -_info.width * .5;
			_info.y = -_info.textHeight;
			TweenMax.to(this, .3, {scaleX: 1, scaleY: 1, alpha: 1, onComplete: onAppear,ease:com.greensock.easing.Strong.easeInOut})
		}

		private function dispose():void
		{
			this.visible = false;
		}
	}
}
