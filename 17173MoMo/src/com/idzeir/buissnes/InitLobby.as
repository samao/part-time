package com.idzeir.buissnes
{
	import com.idzeir.events.InfoEvent;
	
	import flash.utils.setTimeout;
	/**
	 * 读取大厅房间数据
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class InitLobby
	{
		public static const TYPE_WOHAI:String = "wohai";
		public static const TYPE_17173:String = "17173";
		
		private var _type:String = "";
		
		public function InitLobby(type:String)
		{
			_type = type;
			excute();
			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(e:InfoEvent):void
				{
					e.info.code == Enum.ACTION_GET_LOBBY && excute();
				});
		}

		private function excute():void
		{
			G.r.clearRoomData(_type);
			
			switch(_type)
			{
				case TYPE_WOHAI:
					G.h.post(Enum.GET_WOHAI_ANCHOR, null, okWohai, trace);
					break;
				case TYPE_17173:
					G.h.post(Enum.GET_ALL_ANCHOR+"?num=100", null, ok17173, trace);
					break;
			}
			setTimeout(excute,60000);
		}
		
		private function okWohai(value:*):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				var arr:Array = value.data;
				for (var i:uint = 0; i < arr.length; i++)
				{
					G.r.createRoomVo(arr[i],_type);
				}
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_ROOM_INFO, type:_type, data:true}));
			}
			else
			{
				trace(this, "接口返回数据错误",_type);
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_ROOM_INFO, type:_type, data:false}));
			}
		}

		private function ok17173(value:*):void
		{
			if (value["code"] == "000000")
			{
				var arr:Array = value.obj;
				for (var i:uint = 0; i < arr.length; i++)
				{
					if(arr[i].liveStatus==1)G.r.createRoomVo(arr[i],_type);
				}
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_ROOM_INFO, type:_type, data:true}));
			}
			else
			{
				trace(this, "接口返回数据错误",_type);
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_ROOM_INFO,type:_type, data:false}));
			}
		}
	}
}