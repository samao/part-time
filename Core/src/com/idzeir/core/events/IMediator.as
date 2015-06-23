package com.idzeir.core.events
{
	public interface IMediator
	{
		function watch(type:String,handler:Function,host:* = null):void;
		
		function send(type:String,host:* = null):void;
		
		function remove(type:String,handler:Function):void;
	}
}