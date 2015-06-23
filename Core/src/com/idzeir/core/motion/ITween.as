package com.idzeir.core.motion
{
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 29, 2014 6:07:16 AM
	 *
	 **/
	
	public interface ITween
	{
		function to(obj:Object,dur:Number,vars:Object):void;
		
		function killTweensOf(value:Object):void;
		
		function fromTo(value:Object,dur:Number,fromVars:Object,toVars:Object):void
	}
}