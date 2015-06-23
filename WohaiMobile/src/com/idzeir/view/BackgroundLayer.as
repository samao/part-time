package com.idzeir.view
{
	import com.idzeir.assets.StageBglayer;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class BackgroundLayer extends Sprite implements IRender
	{

		private var bglayer:Sprite;

		public function BackgroundLayer()
		{
			super();

			this.mouseChildren = false;
			this.mouseEnabled = false;
			bglayer = new StageBglayer();
			this.addChild(bglayer);
		}

		public function get warp():DisplayObject
		{
			return this;
		}

		public function resize():IRender
		{
			bglayer.width = stage.fullScreenWidth;
			bglayer.height = stage.fullScreenHeight;
			return this;
		}
	}
}