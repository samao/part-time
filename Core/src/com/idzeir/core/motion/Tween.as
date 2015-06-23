package com.idzeir.core.motion
{	
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 7:00:31 PM
	 *
	 **/
	
	public class Tween implements ITween
	{
		public function to(obj:Object,dur:Number,vars:Object):void
		{
			vars.ease = vars["ease"]?vars["ease"]:Sine.easeInOut;
			TweenMax.to(obj,dur,vars);
		}
		
		public function killTweensOf(value:Object):void
		{
			TweenMax.killTweensOf(value);
		}
		
		public function fromTo(value:Object,dur:Number,fromVars:Object,toVars:Object):void
		{
			TweenMax.killTweensOf(value);
			TweenMax.fromTo(value,dur,fromVars,toVars);
		}
	}
}