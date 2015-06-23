package com.idzeir.core.bussies
{
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 9:25:48 AM
	 *
	 **/
	
	public interface IDelegateManager
	{
		function register(value:IDelegate):void;
		
		function unRegister(value:IDelegate):void;
	}
}