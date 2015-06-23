package com.idzeir.view
{
	import com.idzeir.manager.IRoomMgr;
	import com.idzeir.vo.RoomInfoVo;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Nov 30, 2014 12:53:46 PM
	 *
	 **/

	public interface IRoomCard
	{
		function set room(value:RoomInfoVo):void;

		function mgr(value:IRoomMgr,_parent:DisplayObjectContainer):IRoomCard;

		function dispose():void;

		function get warp():DisplayObject;
	}
}