package com.idzeir.flashviewer.bussies.common
{	
	import com.idzeir.core.view.Button;
	
	import flash.filters.DropShadowFilter;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Sep 3, 2014 2:01:35 PM
	 *
	 **/
	
	public class FilterButton extends Button
	{
		public function FilterButton(label:String, handler:Function=null)
		{
			super(label, handler);
			this.filters = [new DropShadowFilter(5,90,0,.15),new DropShadowFilter(5,0,0,.15),new DropShadowFilter(5,180,0,.15)];
		}
		
		override public function set label(value:String):void
		{
			super.label = "<font color='#000000'>" + value + "</font>";
		}
		
	}
}