package com.idzeir.core.bussies
{
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 19, 2014 11:06:23 PM
	 *
	 **/
	
	public interface IDelegate
	{
		/**
		 * 模块加载完成执行
		 */		
		function onloaded(_warp:IModule):void;
		
		/**
		 * 模块卸载完成执行
		 */	
		function unloaded():void;
		
		function set url(value:String):void;
		
		function get url():String;
		/**
		 * 注册模块ui交互事件
		 */		
		function addViewListener():void;
	}
}