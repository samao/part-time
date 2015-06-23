package com.idzeir.view 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public interface ICanvas 
	{
		function set gift(bitmap:Bitmap):void;
		
		function addItem(value:DisplayObject):void;
		
		function select(value:DisplayObject):void;
		
		function get map():Vector.<Point>;
	}
	
}