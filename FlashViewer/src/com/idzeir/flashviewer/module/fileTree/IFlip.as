package com.idzeir.flashviewer.module.fileTree
{
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 28, 2014 5:01:43 PM
	 *
	 **/
	
	public interface IFlip
	{
		function nextPage():void;
		function prePage():void;
		function get curPage():uint;
		function get totalPages():uint;
		function set curPage(value:uint):void;
	}
}