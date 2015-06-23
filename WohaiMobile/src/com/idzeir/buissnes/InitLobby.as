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
		public function InitLobby()
		{
			excute();
			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(e:InfoEvent):void
				{
					e.info.code == Enum.ACTION_GET_LOBBY && excute();
				});
		}

		private function excute():void
		{
			G.r.clearRoomData();
			G.h.post(Enum.GET_ALL_ANCHOR, null, ok, trace);
		}

		private function ok(value:*):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				var arr:Array = value.data;
				for (var i:uint = 0; i < arr.length; i++)
				{
					G.r.createRoomVo(arr[i]);
				}
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_ROOM_INFO, data:true}));
			}
			else
			{
				trace(this, "接口返回数据错误");
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_ROOM_INFO, data:false}));
			}
			
			setTimeout(excute,60000);
		}
	}
}