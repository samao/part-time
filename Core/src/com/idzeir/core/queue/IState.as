package com.idzeir.core.queue
{
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Sep 2, 2014 1:59:03 PM
	 *
	 **/
	
	public interface IState
	{
		/**
		 * 被添加时执行
		 */		
		function added():void;
		/**
		 * 被移除时执行 
		 */		
		function removed():void;
		/**
		 * 进入状态执行 
		 */		
		function enter():void;
		/**
		 * 退出状态时执行 
		 */				
		function exit():void;
		
		function willInterupt():Boolean;
		/**
		 * 所属状态机 
		 * @param mgr
		 */		
		function set owner(value:IMachine):void;
		/**
		 * 完成状态时执行
		 */		
		function complete():void;
	}
}