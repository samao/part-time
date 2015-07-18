package com.idzeir.manager
{
	import com.idzeir.view.IRoomCard;
	import com.idzeir.vo.RoomInfoVo;
	
	import flash.display.DisplayObjectContainer;

	/**
	 * 房间管理涉及数据和ui卡片
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public interface IRoomMgr
	{
		/**
		 * 将object对象转成房间vo
		 * @param data
		 * @return
		 *
		 */
		function createRoomVo(data:Object,type:String):RoomInfoVo;
		/**
		 * 清空房间数据
		 * @return
		 *
		 */
		function clearRoomData(type:String):IRoomMgr;
		/**
		 * 按数组方式返回房间数据
		 * @return
		 *
		 */
		function map():Vector.<RoomInfoVo>;

		/**
		 *  创建roomcardView
		 *
		 */
		function creatRoomCard(_parent:DisplayObjectContainer = null):IRoomCard;

		function recyle(value:IRoomCard):IRoomCard;
	}
}