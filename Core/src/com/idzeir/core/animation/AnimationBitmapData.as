package com.idzeir.core.animation
{	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 24, 2014 2:00:27 PM
	 *
	 **/
	
	public class AnimationBitmapData extends BitmapData
	{
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		private var _frameLabel:String;
		
		public function AnimationBitmapData(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}

		/**
		 * 序列图x的偏移量
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}

		/**
		 * @private
		 */
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}

		/**
		 * 序列图y的偏移量 
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}

		/**
		 * @private
		 */
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}

		public function cloneAnimation():AnimationBitmapData
		{
			var abd:AnimationBitmapData = new AnimationBitmapData(this.width,this.height,true,0x00000000);
			abd.copyPixels(this,this.rect,new Point());
			abd._offsetX = this.offsetX;
			abd._offsetY = this._offsetY;
			return abd
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get frameLabel():String
		{
			return _frameLabel;
		}

		public function set frameLabel(value:String):void
		{
			_frameLabel = value;
		}


	}
}