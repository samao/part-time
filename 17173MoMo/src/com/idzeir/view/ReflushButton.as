package com.idzeir.view
{
	import com.idzeir.core.view.Button;

	import flash.display.DisplayObject;
	import flash.display.Shape;


	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Nov 30, 2014 2:36:37 PM
	 *
	 **/

	public class ReflushButton extends Button implements IRender
	{
		public function ReflushButton(label:String = "刷新", handler:Function = null)
		{
			super(label, handler);

			var bglayer:Shape = new Shape();
			bglayer.graphics.beginFill(0xffffff);
			bglayer.graphics.drawRoundRect(0, 0, 100, 80, 20, 20);
			bglayer.graphics.endFill();
			this.bglayer = bglayer;

			this.width = 46;
			this.height = 30;
			
			visible = false;
		}

		public function get warp():DisplayObject
		{
			return this;
		}

		public function resize():IRender
		{
			this.x = stage.fullScreenWidth - this.width - 5;
			this.y = stage.fullScreenHeight - this.height - 5;
			return this;
		}
	}
}