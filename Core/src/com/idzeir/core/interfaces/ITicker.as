package com.idzeir.core.interfaces
{
	
	/**
	 * 计时器接口
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Mar 10, 2014 9:53:56 PM
	 *
	 **/
	
	public interface ITicker
	{
		/**
		 * 判断是否存在计时器调用
		 */
		function has(handler:Function):Boolean
		/**
		 * 计时器调用 
		 * @param delay 调用间隔
		 * @param handler 处理事件
		 * @param times 调用次数
		 * @param frame 是否是帧调用，默认为时间调用
		 * @param arg 参数
		 * 
		 */		
		function call(delay:uint,handler:Function,times:uint=0, frame:Boolean = false, ...arg):void;
		
		/**
		 * 移除计时器执行 
		 * @param handler 移除的事件
		 * 
		 */		
		function remove(handler:Function):void;
		/**
		 * 计时器开始 
		 * 
		 */		
		function start():void;
		/**
		 * 计时器停止 
		 * 
		 */		
		function stop():void;
		/**
		 * 暂停计时器 
		 * 
		 */		
		function pasue():void;
		/**
		 * 暂停之后恢复计时器 
		 * 
		 */		
		function resume():void;
	}
}