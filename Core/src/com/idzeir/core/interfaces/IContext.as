package com.idzeir.core.interfaces
{
	
	/**
	 * 注册到Context里面的内容必须实现的接口
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Mar 7, 2014 12:58:57 AM
	 *
	 **/
	
	public interface IContext
	{
		/**
		 * 初始化以后被调用 
		 * @param value
		 * 
		 */		
		function startUp(value:*=null):void;
	}
}