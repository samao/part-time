package com.idzeir.core.bussies
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 模块基础接口
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 19, 2014 10:46:48 PM
	 **/
	
	public interface IModule extends IEventDispatcher
	{
		/**
		 * 默认的数据接口,
		 * 可以通过该接口进行数据传递.不支持只写属性,key/value的属性赋值，key为属性,value为数组打包的值
		 * 同时可以可以执行key/value的函数调用，key为函数,value为数组打包的参数，无参数可value = null
		 * @param value
		 */		
		function set data(value:*):void;
		
		/**
		 * 执行模块public方法
		 * @param method 方法名称
		 * @param arg 可选参数
		 */
		function apply(method:String,...arg):*;
		/**
		 * 获取模块文件名字，文件名
		 */		
		function get name():String;
		
		function set name(value:String):void;
		
	}
}