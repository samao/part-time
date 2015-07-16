package com.idzeir.view
{
	import com.idzeir.assets.VideoMaskLayer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;


	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Nov 30, 2014 3:39:47 PM
	 *
	 **/

	public class VideoMasker extends Sprite implements IRender
	{

		private var bglayer:Sprite;

		public function VideoMasker()
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			bglayer = new VideoMaskLayer();
			this.addChild(bglayer);
		}

		public function get warp():DisplayObject
		{
			return this;
		}

		public function resize():IRender
		{
			bglayer.width = stage.fullScreenWidth;
			return this;
		}
	}
}