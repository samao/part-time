package com.idzeir.core.view
{
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-12  上午9:55:23
	 */
	public interface IItemRender
	{
		function startUp(value:Object):void;
		
		function onMouseOver():void;
		
		function onMouseOut():void;
		
		function onSelected():void;
		
		function unSelected():void;
	}
}