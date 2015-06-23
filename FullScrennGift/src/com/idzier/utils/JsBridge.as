package com.idzier.utils 
{
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author idzeir
	 */
	public class JsBridge 
	{
		
		public function JsBridge() 
		{
			
		}
		
		static public function get available():Boolean
		{
			return ExternalInterface.available;
		}
		
		static public function call(method:String, ...args):*
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call(method, args);
			}
			return "调用失败，不在容器中"
		}
		
		static public function addCallback(methodName:String, method:Function):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback(methodName, method);
			}
		}
	}

}