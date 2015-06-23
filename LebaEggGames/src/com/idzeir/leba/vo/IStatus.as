package com.idzeir.leba.vo
{
	public interface IStatus
	{
		function get status():String;
		
		function set status(value:String):void;
		
		function get inReady():Boolean;
		
		function toReady():void;
		
		function get inPlaying():Boolean;
		
		function toPlaying():void;
	}
}