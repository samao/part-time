package com.idzeir.core.queue
{
	
	/**
	 * 状态机接口
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Sep 2, 2014 1:58:16 PM
	 **/
	
	public interface IMachine
	{
		/**
		 * 添加一个状态 
		 * @param _state 状态
		 * @param isQueue 是否添加到队尾
		 * 
		 */		
		function add(_state:IState,isQueue:Boolean = true):void;
		/**
		 * 移除状态 
		 * @param _state
		 * 
		 */		
		function remove(_state:IState):void;
		/**
		 * 在base位置插入一个状态 
		 * @param base
		 * @param target
		 * @param isLeft 是否在base左边
		 * 
		 */		
		function insert(base:IState, target:IState, isLeft:Boolean = false):void;
		
		function pop():void;
		/**
		 * 当前执行位置 
		 * @return 
		 * 
		 */		
		function get current():IState;
		/**
		 * 清空状态机 
		 */		
		function cleanUp():void;
	}
}