package com.idzeir.vo
{
	import com.idzeir.buissnes.InitLobby;

	public class RoomInfoVo
	{
		private var _username:String;
		private var _photo:String;
		private var _usercount:Number;
		private var _roomid:String;
		private var _nickname:String;
		private var _status:Number;
		
		private var _type:String;

		public function RoomInfoVo(data:Object,type:String)
		{
			_type = type;
			update(data);
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get key():String
		{
			return _roomid+"_"+_type;
		}

		/**
		 * 房间状态
		 */
		public function get status():Number
		{
			return _status;
		}

		/**
		 * 用户昵称
		 */
		public function get nickname():String
		{
			return _nickname;
		}

		/**
		 * 当前人数
		 */
		public function get usercount():Number
		{
			return _usercount;
		}

		/**
		 * 房间图片
		 */
		public function get photo():String
		{
			return _photo;
		}

		/**
		 * 用户名
		 */
		public function get username():String
		{
			return _username;
		}

		/**
		 * 房间id
		 */
		public function get roomid():String
		{
			return _roomid;
		}

		private function update(data:Object):void
		{
			if(_type == InitLobby.TYPE_WOHAI)
			{
				this._username = data["username"];
				this._photo = data["photo"];
				this._usercount = data["usercount"];
				this._roomid = data["roomid"];
				this._nickname = data["nickname"];
				this._status = data["status"];
				return;
			}
			this._username = data["title"];
			this._photo = data["picUrl"];
			this._usercount = data["userCount"];
			this._roomid = data["roomId"];
			this._nickname = data["nickName"];
			this._status = data["liveStatus"];
		}

		public function toString():String
		{
			return "昵称：" + this.nickname + " 房间号：" + this.roomid + " 房间人数：" + this.usercount + " 头像：" + this.photo;
		}
	}
}