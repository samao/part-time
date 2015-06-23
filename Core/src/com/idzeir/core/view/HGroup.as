package com.idzeir.core.view
{
	import flash.display.DisplayObject;

	/** 
	 * @author idzeir
	 * 创建时间：2014-2-10  下午2:11:08
	 */
	public class HGroup extends Group
	{
		private var hGap:Number=5;		
		
		protected var _leftmargin:Number=0;
		
		static public const TOP:String = "top";
		static public const MIDDLE:String = "middle";
		static public const BUTTOM:String = "buttom";
		
		private var _valign:String;
		
		public function HGroup()
		{
			super();
			valign = TOP;
		}
		
		public function get valign():String
		{
			return _valign;
		}

		public function set valign(value:String):void
		{
			_valign = value;
			rePos();
		}

		public function set leftmargin(value:Number):void
		{
			_leftmargin = value;
			rePos();
		}

		override protected function rePos():void
		{
			super.rePos();
			var maxH:Number = this.bounds.height;
			
			var tar:DisplayObject;
			var xPos:Number=_leftmargin;
			
			for(var i:uint = 0;i<_content.numChildren;i++)
			{
				if(tar)
				{
					xPos = tar.x + tar.width + hGap;
				}
				tar=_content.getChildAt(i);
				tar.x = xPos;
				switch(this._valign)
				{
					case TOP:
						tar.y = 0;
						break;
					case MIDDLE:
						tar.y = (maxH - tar.height)>>1;
						break;
					case BUTTOM:
						tar.y = (maxH - tar.height);
						break;
				}
			}
		}	
		
		public function set gap(value:Number):void
		{
			hGap=value;
			rePos();
		}
	}
}