package com.idzeir.manager
{
	import com.idzeir.view.IRoomCard;
	import com.idzeir.view.RoomCardView;
	import com.idzeir.vo.RoomInfoVo;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * 管理器实现
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class RoomManager implements IRoomMgr
	{
		private var rooms:Dictionary;

		private var cards:Vector.<IRoomCard>;

		public function RoomManager()
		{

		}

		public function createRoomVo(data:Object):RoomInfoVo
		{
			rooms ||= new Dictionary(true);
			var roomVo:RoomInfoVo;
			if (!rooms[data["roomId"]])
			{
				rooms[data["roomId"]] = new RoomInfoVo(data);
			}
			roomVo = rooms[data["roomId"]];
			addRoom(roomVo);
			return roomVo;
		}

		public function clearRoomData():IRoomMgr
		{
			for (var i:* in this.rooms)
			{
				delete rooms[i];
			}
			return this;
		}

		private function addRoom(room:RoomInfoVo):void
		{
			rooms ||= new Dictionary(true);
			if (!rooms[room.roomid])
			{
				rooms[room.roomid] = room;
			}
		}

		public function map():Vector.<RoomInfoVo>
		{
			var _map:Vector.<RoomInfoVo> = new Vector.<RoomInfoVo>();

			for (var i:String in rooms)
			{
				_map.push(rooms[i]);
			}
			_map.sort(sort);
			return _map;
		}

		private function sort(a:RoomInfoVo, b:RoomInfoVo):int
		{
			if (a.usercount > b.usercount)
				return -1;
			if (a.usercount < b.usercount)
				return 1;
			return 0;
		}

		public function creatRoomCard(_parent:DisplayObjectContainer = null):IRoomCard
		{
			cards ||= new Vector.<IRoomCard>();
			if (cards.length == 0)
			{
				var roomCard:RoomCardView = new RoomCardView();
				roomCard.mgr(this,_parent);
				cards.push(roomCard);
			}
			return cards.shift();
		}

		public function recyle(value:IRoomCard):IRoomCard
		{
			cards ||= new Vector.<IRoomCard>();
			cards.push(value);
			return value;
		}
	}
}